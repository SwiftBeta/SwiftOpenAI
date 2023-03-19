import Foundation

public struct ChatCompletionsDataModel: Decodable {
    public var id: String
    public var object: String
    public var created: Int
    public var choices: [ChoiceDataModel]
    public var usage: UsageDataModel
}

public struct UsageDataModel: Decodable {
    public var promptTokens: Int
    public var completionTokens: Int
    public var totalTokens: Int
}

public struct ChoiceDataModel: Decodable {
    public var index: Int
    public var finishReason: String?
    public var message: MessageDataModel
}

public struct MessageDataModel: Decodable {
    public var role: String
    public var content: String
}
