import Foundation

public struct ModerationDataModel: Decodable {
    public let id: String
    public let model: String
    public let results: [ModerationResultDataModel]
}

public struct ModerationResultDataModel: Decodable {
    public let categories: ModerationCategoriesDataModel
    public let categoryScores: ModerationCategoriesScoreDataModel
    public let flagged: Bool
}

public struct ModerationCategoriesDataModel: Decodable {
    public let hate: Bool
    public let hateThreatening: Bool
    public let selfHarm: Bool
    public let sexual: Bool
    public let sexualMinors: Bool
    public let violence: Bool
    public let violenceGraphic: Bool

    enum CodingKeys: String, CodingKey {
        case hate
        case hateThreatening = "hate/threatening"
        case selfHarm = "self-harm"
        case sexual
        case sexualMinors = "sexual/minors"
        case violence
        case violenceGraphic = "violence/graphic"
    }
}

public struct ModerationCategoriesScoreDataModel: Decodable {
    public let hate: Double
    public let hateThreatening: Double
    public let selfHarm: Double
    public let sexual: Double
    public let sexualMinors: Double
    public let violence: Double
    public let violenceGraphic: Double

    enum CodingKeys: String, CodingKey {
        case hate
        case hateThreatening = "hate/threatening"
        case selfHarm = "self-harm"
        case sexual
        case sexualMinors = "sexual/minors"
        case violence
        case violenceGraphic = "violence/graphic"
    }
}
