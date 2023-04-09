import Foundation

struct ModerationEndpoint: Endpoint {
    private let input: String

    var method: HTTPMethod {
        .POST
    }

    var path: String = "moderations"

    init(input: String) {
        self.input = input
    }

    var parameters: [String: Any]? {
        ["input": self.input as Any]
    }
}
