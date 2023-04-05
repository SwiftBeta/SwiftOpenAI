import Foundation

protocol EditsRequestProtocol {
    func execute(api: API,
                 apiKey: String,
                 model: OpenAIModelType,
                 input: String,
                 instruction: String) async throws -> EditsDataModel?
}

final public class EditsRequest: EditsRequestProtocol  {
    public typealias Init = (_ api: API,
                             _ apiKey: String,
                             _ model: OpenAIModelType,
                             _ input: String,
                             _ instructions: String) async throws -> EditsDataModel?
    
    public init() { }
    
    public func execute(api: API,
                        apiKey: String,
                        model: OpenAIModelType,
                        input: String,
                        instruction: String) async throws -> EditsDataModel? {
        var endpoint = OpenAIEndpoints.edits(model: model, input: input, instruction: instruction).endpoint
        api.routeEndpoint(&endpoint, environment: OpenAIEnvironmentV1())
        
        var urlRequest = api.buildURLRequest(endpoint: endpoint)
        api.addHeaders(urlRequest: &urlRequest,
                       headers: ["Content-Type" : "application/json",
                                 "Authorization" : "Bearer \(apiKey)"])
        
        let result = await api.execute(with: urlRequest)
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return try api.parse(result,
                             type: EditsDataModel.self,
                             jsonDecoder: jsonDecoder,
                             errorType: OpenAIAPIError.self)
    }
}
