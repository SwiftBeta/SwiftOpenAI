import Foundation

public struct EmbeddingResponseDataModel: Decodable {
    public let object: String
    public let data: [EmbeddingDataModel]
    public let model: String
    public let usage: EmbeddingUsageDataModel
}

public struct EmbeddingDataModel: Decodable {
    public let object: String
    public let embedding: [Float]
    public let index: Int
}

public struct EmbeddingUsageDataModel: Decodable {
    public let promptTokens: Int
    public let totalTokens: Int
}
