import SwiftData
import SwiftUI

struct ChatListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Chat.updatedAt, order: .reverse) private var chats: [Chat]
    @State private var model = ChatListModel()
    @State private var path: [UUID] = []

    var body: some View {
        NavigationStack(path: $path) {
            Group {
                if chats.isEmpty {
                    ContentUnavailableView {
                        Label("Пока нет чатов", systemImage: "bubble.left.and.bubble.right")
                    } actions: {
                        Button("Новый чат", action: createChat)
                    }
                } else {
                    List {
                        ForEach(chats) { chat in
                            NavigationLink(value: chat.id) {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(chat.title)
                                        .font(.body)
                                    Text(chat.updatedAt, style: .relative)
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button("Удалить", role: .destructive) {
                                    model.delete(chat, in: modelContext)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Чаты")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: createChat) {
                        Image(systemName: "square.and.pencil")
                    }
                    .accessibilityLabel("Новый чат")
                }
            }
            .navigationDestination(for: UUID.self) { chatID in
                ChatView(chatID: chatID)
            }
        }
    }

    private func createChat() {
        guard let id = model.createChat(in: modelContext) else { return }
        path.append(id)
    }
}

#Preview {
    ChatListView()
        .modelContainer(for: Chat.self, inMemory: true)
}
