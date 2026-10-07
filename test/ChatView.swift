import SwiftData
import SwiftUI

struct ChatView: View {
    let chatID: UUID
    var service: any ChatService = GroqChatService()
    var requestOnAppear = false
    @Query private var chats: [Chat]

    var body: some View {
        if let chat = chats.first(where: { $0.id == chatID }) {
            ChatScreen(chat: chat, service: service, requestOnAppear: requestOnAppear)
        }
    }
}

private struct ChatScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var chat: Chat
    let service: any ChatService
    var requestOnAppear = false
    @State private var model = ChatScreenModel()
    @State private var didRequestOnAppear = false
    @State private var followsBottom = true
    @State private var isAtBottom = true
    @State private var scrollPhase: ScrollPhase = .idle

    var body: some View {
        VStack(spacing: 0) {
            messages
            if let errorMessage = model.errorMessage {
                HStack(alignment: .center, spacing: 12) {
                    Text(errorMessage)
                        .font(.subheadline)
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Button("Повторить", action: retry)
                        .font(.subheadline)
                        .buttonStyle(.borderless)
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
            }
            composer
        }
        .navigationTitle(chat.title)
        .navigationBarTitleDisplayMode(.inline)
        .task(id: requestOnAppear ? chat.messages.count : 0) {
            guard requestOnAppear, !didRequestOnAppear, chat.messages.contains(where: { $0.role == .user }) else { return }
            didRequestOnAppear = true
            model.retry(in: chat, context: modelContext, using: service)
        }
    }

    private var messages: some View {
        let items = chat.messages.sorted { $0.createdAt < $1.createdAt }
        return Group {
            if items.isEmpty && !model.isWaitingForText {
                Text("Напишите сообщение")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(items) { message in
                                MessageBubble(role: message.role, text: displayText(for: message))
                                    .id(message.id)
                            }
                            if model.isWaitingForText {
                                HStack {
                                    ProgressView()
                                    Spacer(minLength: 48)
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 12)
                    }
                    .defaultScrollAnchor(.bottom)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onScrollGeometryChange(for: Bool.self) { geometry in
                        Self.nearBottom(geometry)
                    } action: { _, atBottom in
                        isAtBottom = atBottom
                    }
                    .onScrollPhaseChange { oldPhase, newPhase, context in
                        scrollPhase = newPhase
                        updateFollow(
                            phase: newPhase,
                            previous: oldPhase,
                            atBottom: Self.nearBottom(context.geometry)
                        )
                    }
                    .onChange(of: isAtBottom) { _, atBottom in
                        guard scrollPhase == .interacting || scrollPhase == .decelerating else { return }
                        if !atBottom {
                            followsBottom = false
                        }
                    }
                    .onChange(of: model.streamingText) { _, text in
                        guard followsBottom, !text.isEmpty, let lastID = items.last?.id else { return }
                        proxy.scrollTo(lastID, anchor: .bottom)
                    }
                }
            }
        }
    }

    private var composer: some View {
        @Bindable var model = model
        return HStack(alignment: .bottom, spacing: 8) {
            TextField("Сообщение", text: $model.draft, axis: .vertical)
                .font(.body)
                .lineLimit(1...5)
                .textFieldStyle(.plain)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(.fill.tertiary, in: RoundedRectangle(cornerRadius: 18, style: .continuous))

            if model.isGenerating {
                Button("Стоп", action: stop)
                    .font(.body)
                    .buttonStyle(.borderless)
            } else {
                Button(action: send) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.title2)
                }
                .buttonStyle(.borderless)
                .accessibilityLabel("Отправить")
                .disabled(!model.canSend)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(.bar)
    }

    private func displayText(for message: Message) -> String {
        if message.id == model.streamingMessageID {
            return model.streamingText
        }
        return message.text
    }

    private func send() {
        followsBottom = true
        model.send(in: chat, context: modelContext, using: service)
    }

    private static func nearBottom(_ geometry: ScrollGeometry) -> Bool {
        let threshold: CGFloat = 40
        if geometry.contentSize.height <= geometry.containerSize.height + threshold {
            return true
        }
        return geometry.contentSize.height - geometry.visibleRect.maxY <= threshold
    }

    private func updateFollow(phase: ScrollPhase, previous: ScrollPhase, atBottom: Bool) {
        if phase == .interacting || phase == .decelerating {
            if !atBottom {
                followsBottom = false
            }
            return
        }
        if phase == .idle,
           previous == .interacting || previous == .decelerating,
           atBottom {
            followsBottom = true
        }
    }

    private func retry() {
        model.retry(in: chat, context: modelContext, using: service)
    }

    private func stop() {
        model.stop()
    }
}

private struct MessageBubble: View {
    let role: MessageRole
    let text: String

    var body: some View {
        HStack {
            if role == .user {
                Spacer(minLength: 48)
            }

            Text(text)
                .font(.body)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(.fill.tertiary, in: RoundedRectangle(cornerRadius: 16, style: .continuous))

            if role == .assistant {
                Spacer(minLength: 48)
            }
        }
    }
}

#Preview("Лимит API") {
    APILimitPreview()
        .modelContainer(for: Chat.self, inMemory: true)
}

private struct APILimitPreview: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Chat.createdAt) private var chats: [Chat]
    @State private var didPrepare = false

    var body: some View {
        NavigationStack {
            if let chat = chats.first {
                ChatView(
                    chatID: chat.id,
                    service: APILimitPreviewService(),
                    requestOnAppear: true
                )
            }
        }
        .task {
            guard !didPrepare else { return }
            didPrepare = true
            guard chats.isEmpty else { return }

            let chat = Chat(title: "Новый чат")
            let message = Message(role: .user, text: "Привет")
            modelContext.insert(chat)
            modelContext.insert(message)
            message.chat = chat
            if !chat.messages.contains(where: { $0.id == message.id }) {
                chat.messages.append(message)
            }

            do {
                try modelContext.save()
            } catch {
                modelContext.rollback()
            }
        }
    }
}

private struct APILimitPreviewService: ChatService {
    private static let responseStatusCode = 429
    private static let responseBody = """
    {"error":{"message":"Rate limit reached","type":"tokens","code":"rate_limit_exceeded"}}
    """

    func streamReply(to _: [ChatServiceMessage]) -> AsyncThrowingStream<String, any Error> {
        let failure = groqChatFailure(statusCode: Self.responseStatusCode, body: Self.responseBody)
        return AsyncThrowingStream { continuation in
            continuation.finish(throwing: failure)
        }
    }
}
