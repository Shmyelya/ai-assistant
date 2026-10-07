import Foundation
import SwiftData

@MainActor
@Observable
final class ChatScreenModel {
    var draft = ""

    var canSend: Bool {
        !trimmedDraft.isEmpty
    }

    func send(in chat: Chat, context: ModelContext) {
        let text = trimmedDraft
        guard !text.isEmpty else { return }

        let isFirstUserMessage = !chat.messages.contains { $0.role == .user }
        let message = Message(role: .user, text: text)
        context.insert(message)
        message.chat = chat
        if !chat.messages.contains(where: { $0.id == message.id }) {
            chat.messages.append(message)
        }

        if isFirstUserMessage {
            chat.title = title(from: text)
        }
        chat.updatedAt = .now

        do {
            try context.save()
            draft = ""
        } catch {
            context.rollback()
        }
    }

    private var trimmedDraft: String {
        draft.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func title(from text: String) -> String {
        let firstLine = text.split(whereSeparator: \.isNewline).first.map(String.init) ?? text
        let trimmedLine = firstLine.trimmingCharacters(in: .whitespaces)
        let value = trimmedLine.isEmpty ? text : trimmedLine
        return String(value.prefix(40))
    }
}
