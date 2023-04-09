import Foundation

public struct ChatCompletionsStreamDataModel: Decodable {
    public var id: String
    public var object: String
    public var created: Int
    public var model: String
    public var choices: [ChoicesStreamDataModel]

    static var finished: ChatCompletionsStreamDataModel = {
        .init(id: UUID().uuidString,
              object: "",
              created: 1,
              model: "",
              choices: [.init(index: 0, finishReason: "stop")])
    }()
}

public struct ChoicesStreamDataModel: Decodable {
    public var delta: DeltaDataModel?
    public var index: Int
    public var finishReason: String?
}

public struct DeltaDataModel: Decodable {
    public let content: String?

    enum CodingKeys: String, CodingKey {
        case content
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        content = try container.decodeIfPresent(String.self, forKey: .content)
    }
}
