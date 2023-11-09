import Foundation

protocol CreateImagesRequestProtocol {
    func execute(api: API,
                 apiKey: String,
                 model: OpenAIImageModelType,
                 prompt: String,
                 numberOfImages: Int,
                 size: ImageSize) async throws -> CreateImageDataModel?
}

final public class CreateImagesRequest: CreateImagesRequestProtocol {
    public typealias Init = (_ api: API,
                             _ apiKey: String,
                             _ model: OpenAIImageModelType,
                             _ prompt: String,
                             _ numberOfImages: Int,
                             _ size: ImageSize) async throws -> CreateImageDataModel?

    public init() { }

    public func execute(api: API,
                        apiKey: String,
                        model: OpenAIImageModelType,
                        prompt: String,
                        numberOfImages: Int,
                        size: ImageSize) async throws -> CreateImageDataModel? {
        var endpoint = OpenAIEndpoints.createImage(model: model,
                                                   prompt: prompt,
                                                   numberOfImages: numberOfImages,
                                                   size: size).endpoint
        api.routeEndpoint(&endpoint, environment: OpenAIEnvironmentV1())

        var urlRequest = api.buildURLRequest(endpoint: endpoint)
        api.addHeaders(urlRequest: &urlRequest,
                       headers: ["Content-Type": "application/json",
                                 "Authorization": "Bearer \(apiKey)"])

        let result = await api.execute(with: urlRequest)

        return try api.parse(result,
                             type: CreateImageDataModel.self,
                             jsonDecoder: JSONDecoder(),
                             errorType: OpenAIAPIError.self)
    }
}
