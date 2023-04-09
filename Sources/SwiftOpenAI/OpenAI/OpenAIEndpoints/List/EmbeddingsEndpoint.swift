import Foundation

struct CreateEmbeddingsEndpoint: Endpoint {
    private let model: OpenAIModelType
    private let input: String

    var method: HTTPMethod {
        .POST
    }

    var path: String = "embeddings"

    init(model: OpenAIModelType,
         input: String) {
        self.model = model
        self.input = input
    }

    var parameters: [String: Any]? {
        ["model": self.model.name as Any,
         "input": self.input as Any
        ]
    }
}
