import Foundation

public struct CompletionsDataModel: Decodable {
    public var id: String
    public var object: String
    public var created: Int
    public var model: String
    public var choices: [CompletionsChoiceDataModel]
    public var usage: CompletionsUsageDataModel
}

public struct CompletionsUsageDataModel: Decodable {
    public var promptTokens: Int
    public var completionTokens: Int
    public var totalTokens: Int
}

public struct CompletionsChoiceDataModel: Decodable {
    public var text: String
    public var index: Int
    public var finishReason: String?
}
