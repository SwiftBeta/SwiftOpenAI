import Foundation

struct EditsEndpoint: Endpoint {
    private let model: OpenAIModelType
    private let input: String
    private let instruction: String

    var method: HTTPMethod {
        .POST
    }

    var path: String = "edits"

    init(model: OpenAIModelType,
         input: String,
         instruction: String) {
        self.model = model
        self.input = input
        self.instruction = instruction
    }

    var parameters: [String: Any]? {
        ["model": self.model.name as Any,
         "input": self.input as Any,
         "instruction": self.instruction as Any
        ]
    }
}
