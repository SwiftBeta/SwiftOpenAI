import Foundation

struct CreateImageEndpoint: Endpoint {
    private let prompt: String
    private let numberOfImages: Int
    private let size: String

    var method: HTTPMethod {
        .POST
    }

    var path: String = "images/generations"

    init(prompt: String,
         numberOfImages: Int,
         size: ImageSize) {
        self.prompt = prompt
        self.numberOfImages = numberOfImages
        self.size = size.rawValue
    }

    var parameters: [String: Any]? {
        ["prompt": self.prompt as Any,
         "n": self.numberOfImages as Any,
         "size": self.size as Any]
    }
}
