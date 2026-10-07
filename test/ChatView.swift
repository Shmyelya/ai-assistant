import SwiftData
import SwiftUI

struct ChatView: View {
    let chatID: UUID
    @Query private var chats: [Chat]

    var body: some View {
        if let chat = chats.first(where: { $0.id == chatID }) {
            ChatScreen(chat: chat)
        }
    }
}

private struct ChatScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var chat: Chat
    @State private var model = ChatScreenModel()

    var body: some View {
        VStack(spacing: 0) {
            messages
            composer
        }
        .navigationTitle(chat.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    private var messages: some View {
        let items = chat.messages.sorted { $0.createdAt < $1.createdAt }
        return Group {
            if items.isEmpty {
                Text("Напишите сообщение")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(items) { message in
                            MessageBubble(message: message)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 12)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
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

            Button(action: send) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.title2)
            }
            .buttonStyle(.borderless)
            .accessibilityLabel("Отправить")
            .disabled(!model.canSend)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(.bar)
    }

    private func send() {
        model.send(in: chat, context: modelContext)
    }
}

private struct MessageBubble: View {
    let message: Message

    var body: some View {
        HStack {
            if message.role == .user {
                Spacer(minLength: 48)
            }

            Text(message.text)
                .font(.body)
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .background(.fill.tertiary, in: RoundedRectangle(cornerRadius: 16, style: .continuous))

            if message.role == .assistant {
                Spacer(minLength: 48)
            }
        }
    }
}
