import XCTest
@testable import SwiftOpenAI

final class ChatCompletionParserSpec: XCTestCase {
    private var api = API()
    
    func testAsyncAPIRequest_ParsesValidJSONToChatCompletionsDataModel() async throws {
        let jsonData = loadJSON(name: "chat.completions")
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let dataModel = try! api.parse(.success(jsonData), type: ChatCompletionsDataModel.self, jsonDecoder: jsonDecoder, errorType: OpenAIAPIError.self)
        
        XCTAssertNotNil(dataModel)
        XCTAssertEqual(dataModel?.id, "chatcmpl-123")
        XCTAssertEqual(dataModel?.object, "chat.completion")
        XCTAssertEqual(dataModel?.created, 1677652288)
        XCTAssertEqual(dataModel?.choices.count, 1)
        XCTAssertEqual(dataModel?.choices[0].index, 0)
        XCTAssertEqual(dataModel?.choices[0].message.role, "assistant")
        XCTAssertEqual(dataModel?.choices[0].message.content, "Hello there, how may I assist you today?")
        XCTAssertEqual(dataModel?.choices[0].finishReason, "stop")
        XCTAssertEqual(dataModel?.usage.promptTokens, 9)
        XCTAssertEqual(dataModel?.usage.completionTokens, 12)
        XCTAssertEqual(dataModel?.usage.totalTokens, 21)
    }
    
    func testAsyncAPIRequest_FailWithIncorrectJSONDecoderStrategy() async throws {
        let jsonData = loadJSON(name: "chat.completions")
        
        do {
            let _ = try api.parse(.success(jsonData), type: ChatCompletionsDataModel.self, jsonDecoder: JSONDecoder(), errorType: OpenAIAPIError.self)
        } catch let error as APIError {
            switch error {
            case .decodable(let decodingError):
                switch decodingError {
                case .keyNotFound(let codingKey, let context):
                    XCTAssertEqual(codingKey.stringValue, "promptTokens")
                    XCTAssertEqual(context.debugDescription, "No value associated with key CodingKeys(stringValue: \"promptTokens\", intValue: nil) (\"promptTokens\").")
                default:
                    XCTFail()
                }
            default:
                XCTFail()
            }
        }
    }
    
    func testAsyncAPIRequest_ParsesValidErrorJSONToErrorDataModel() async throws {
        let jsonData = loadJSON(name: "chat.completions.error.invalid_api_key")
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            let _ = try api.parse(.failure(.jsonResponseError(jsonData.toJSONString()!)), type: ChatCompletionsDataModel.self, jsonDecoder: jsonDecoder, errorType: OpenAIAPIError.self)
        } catch let error as OpenAIAPIError {
            XCTAssertNotNil(error)
            XCTAssertEqual(error.code, "invalid_api_key")
            XCTAssertEqual(error.message, "Incorrect API key provided: YOUR_API_KEY. You can find your API key at https://platform.openai.com/account/api-keys.")
            XCTAssertEqual(error.type, "invalid_request_error")
            XCTAssertEqual(error.param, "")
        }
    }
}
