import Foundation

public struct MessageChatImageInput: Identifiable, Hashable {
    public var id: UUID
    public var text: String
    public var imageURL: String
    public var role: MessageRoleType
    
    public init(text: String, imageURL: String, role: MessageRoleType) {
        self.id = UUID()
        self.text = text
        self.role = role
        self.imageURL = imageURL
    }
}
