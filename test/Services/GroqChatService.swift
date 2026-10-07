import Foundation

struct GroqChatService: ChatService, Sendable {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func streamReply(to messages: [ChatServiceMessage]) -> AsyncThrowingStream<String, any Error> {
        let session = session
        return AsyncThrowingStream { continuation in
            let task = Task {
                await Self.deliver(messages: messages, session: session, continuation: continuation)
            }
            continuation.onTermination = { @Sendable _ in
                task.cancel()
            }
        }
    }

    private static func deliver(
        messages: [ChatServiceMessage],
        session: URLSession,
        continuation: AsyncThrowingStream<String, any Error>.Continuation
    ) async {
        do {
            try await streamBody(messages: messages, session: session, continuation: continuation)
            continuation.finish()
        } catch is CancellationError {
            continuation.finish()
        } catch let error as URLError where error.code == .cancelled {
            continuation.finish()
        } catch let error as ChatServiceError {
            continuation.finish(throwing: error)
        } catch {
            continuation.finish(throwing: ChatServiceError.failed)
        }
    }

    private static func streamBody(
        messages: [ChatServiceMessage],
        session: URLSession,
        continuation: AsyncThrowingStream<String, any Error>.Continuation
    ) async throws {
        let key = Secrets.decodedKey()
        guard !key.isEmpty else { throw ChatServiceError.failed }

        guard let url = URL(string: "https://api.groq.com/openai/v1/chat/completions") else {
            throw ChatServiceError.failed
        }

        let payload = CompletionRequest(
            model: "openai/gpt-oss-120b",
            stream: true,
            reasoningEffort: "low",
            messages: messages.map { CompletionMessage(role: $0.role, content: $0.content) }
        )

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(key)", forHTTPHeaderField: "Authorization")
        request.httpBody = try JSONEncoder().encode(payload)

        let (bytes, response) = try await session.bytes(for: request)
        try validate(response)

        let decoder = JSONDecoder()
        for try await line in bytes.lines {
            try Task.checkCancellation()
            guard let event = try ServerSentEvent.parse(line: line, decoder: decoder) else { continue }
            switch event {
            case .done:
                return
            case .text(let text):
                continuation.yield(text)
            }
        }
    }

    private static func validate(_ response: URLResponse) throws {
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw ChatServiceError.failed
        }
    }
}

private struct CompletionRequest: Encodable {
    var model: String
    var stream: Bool
    var reasoningEffort: String
    var messages: [CompletionMessage]

    private enum CodingKeys: String, CodingKey {
        case model
        case stream
        case reasoningEffort = "reasoning_effort"
        case messages
    }
}

private struct CompletionMessage: Encodable {
    var role: String
    var content: String
}

private enum ServerSentEvent {
    case done
    case text(String)

    static func parse(line: String, decoder: JSONDecoder) throws -> ServerSentEvent? {
        let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.hasPrefix("data:") else { return nil }

        var payload = trimmed.dropFirst(5)
        if payload.first == " " {
            payload = payload.dropFirst()
        }
        let jsonText = payload.trimmingCharacters(in: .whitespaces)
        if jsonText == "[DONE]" {
            return .done
        }
        guard let data = jsonText.data(using: .utf8) else { return nil }

        let chunk: Chunk
        do {
            chunk = try decoder.decode(Chunk.self, from: data)
        } catch {
            return nil
        }
        if chunk.error != nil {
            throw ChatServiceError.failed
        }
        let text = chunk.choices?.compactMap { $0.delta?.content }.joined() ?? ""
        guard !text.isEmpty else { return nil }
        return .text(text)
    }

    private struct Chunk: Decodable {
        struct Choice: Decodable {
            struct Delta: Decodable {
                var content: String?
            }

            var delta: Delta?
        }

        struct Failure: Decodable {}

        var choices: [Choice]?
        var error: Failure?
    }
}
