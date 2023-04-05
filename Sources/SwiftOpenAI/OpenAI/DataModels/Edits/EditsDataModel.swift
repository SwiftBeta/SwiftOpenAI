import Foundation

public struct EditsDataModel: Decodable {
    public var object: String
    public var created: Int
    public var choices: [EditsChoiceDataModel]
    public var usage: CompletionsUsageDataModel
}

public struct EditsUsageDataModel: Decodable {
    public var promptTokens: Int
    public var completionTokens: Int
    public var totalTokens: Int
}

public struct EditsChoiceDataModel: Decodable {
    public var text: String
    public var index: Int
}
