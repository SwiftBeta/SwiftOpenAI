import Foundation

public struct CreateImageDataModel: Decodable {
    public let created: Int
    public let data: [CreateImageURLDataModel]
}

public struct CreateImageURLDataModel: Decodable {
    public let url: String
}
