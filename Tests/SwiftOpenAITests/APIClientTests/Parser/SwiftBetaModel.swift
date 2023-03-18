import Foundation

struct SwiftBetaModel: Decodable {
    let user: String
    let numberOfVideos: Int
    let topics: [String]
    
    enum CodingKeys: String, CodingKey {
        case user
        case numberOfVideos = "number_of_videos"
        case topics
    }
}
