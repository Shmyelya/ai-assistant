import SwiftData
import SwiftUI

struct ChatView: View {
    let chatID: UUID
    var service: any ChatService = GroqChatService()
    @Query private var chats: [Chat]

    var body: some View {
        if let chat = chats.first(where: { $0.id == chatID }) {
            ChatScreen(chat: chat, service: service)
        }
    }
}

private struct ChatScreen: View {
    @Environment(\.modelContext) private var modelContext
    @Bindable var chat: Chat
    let service: any ChatService
    @State private var model = ChatScreenModel()

    private let loadingAnchor = "loading"

    var body: some View {
        VStack(spacing: 0) {
            messages
            if let errorMessage = model.errorMessage {
                Text(errorMessage)
                    .font(.subheadline)
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
            }
            composer
        }
        .navigationTitle(chat.title)
        .navigationBarTitleDisplayMode(.inline)
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
                                .id(loadingAnchor)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 12)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .onChange(of: model.scrollTick) { _, _ in
                        if model.isWaitingForText {
                            proxy.scrollTo(loadingAnchor, anchor: .bottom)
                        } else if let lastID = items.last?.id {
                            proxy.scrollTo(lastID, anchor: .bottom)
                        }
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

    private func displayText(for message: Message) -> String {
        if message.id == model.streamingMessageID {
            return model.streamingText
        }
        return message.text
    }

    private func send() {
        model.send(in: chat, context: modelContext, using: service)
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
