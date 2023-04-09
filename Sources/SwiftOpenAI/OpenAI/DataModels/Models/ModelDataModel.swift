import Foundation

public struct ModelListDataModel: Decodable {
    let data: [ModelDataModel]
    let object: String

    public init(data: [ModelDataModel], object: String) {
        self.data = data
        self.object = object
    }
}

public struct ModelDataModel: Decodable {
    let id: String
    let created: Int
    let object: String
    let ownedBy: String

    private enum CodingKeys: String, CodingKey {
        case id
        case created
        case object
        case ownedBy
    }
}
