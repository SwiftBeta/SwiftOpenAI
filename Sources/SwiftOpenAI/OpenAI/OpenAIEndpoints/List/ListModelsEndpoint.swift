import Foundation

struct ListModelsEndpoint: Endpoint {
    var method: HTTPMethod {
        .GET
    }

    var path: String = "models"
}
