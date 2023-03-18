import Foundation

public struct MessageChatGPT: Identifiable, Hashable {
    public var id: UUID
    public var text: String
    public var role: String
    
    public init(text: String, role: String) {
        self.id = UUID()
        self.text = text
        self.role = role
    }
}
