import Foundation

public struct ChatCompletionsStreamDataModel: Decodable {
    public var id: String
    public var object: String
    public var created: Int
    public var model: String
    public var choices: [ChoicesStreamDataModel]
}

public struct ChoicesStreamDataModel: Decodable {
    public var delta: DeltaDataModel
    public var index: Int
    public var finishReason: Bool?
}

public struct DeltaDataModel: Decodable {
    public let content: String?
}
