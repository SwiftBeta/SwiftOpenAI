import Foundation

struct OpenAIAPIError: Decodable, Error {
    let code: String?
    let message: String
    let param: String?
    let type: String

    private enum CodingKeys: String, CodingKey {
        case error
    }

    private enum ErrorKeys: String, CodingKey {
        case code, message, param, type
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let errorContainer = try container.nestedContainer(keyedBy: ErrorKeys.self, forKey: .error)

        code = try errorContainer.decodeIfPresent(String.self, forKey: .code)
        message = try errorContainer.decode(String.self, forKey: .message)
        param = try errorContainer.decodeIfPresent(String.self, forKey: .param)
        type = try errorContainer.decode(String.self, forKey: .type)
    }
}
