import Foundation

public struct MessageChatGPT: Identifiable, Hashable {
    public var id: UUID
    public var text: String
    public var role: MessageRoleType

    public init(text: String, role: MessageRoleType) {
        self.id = UUID()
        self.text = text
        self.role = role
    }
}
