import XCTest
@testable import SwiftOpenAI

final class CompletionsEndpointSpec: XCTestCase {
    func testEndpointCompletions_WithDavinciModelAndPrompt_CreatesCorrectEndpointParameters() throws {
        let model: OpenAIModelType = .gpt3_5(.gpt_3_5_turbo_1106)
        let optionalParameters: CompletionsOptionalParameters = .init(prompt: "Say this is a test")
        let sut = OpenAIEndpoints.completions(model: model, optionalParameters: optionalParameters).endpoint
        
        let modelParameter = sut.parameters!["model"] as! String
        let promptParameter = sut.parameters!["prompt"] as! String
        
        XCTAssertEqual(sut.path, "completions")
        XCTAssertEqual(sut.method, .POST)
        XCTAssertEqual(sut.parameters?.count, 14)
        XCTAssertEqual(modelParameter, model.name)
        XCTAssertEqual(promptParameter, optionalParameters.prompt)
    }
    
    func testEndpointCompletions_WithDavinciModelAndPrompt_WithOptionalParameters_CreatesCorrectEndpointParameters() throws {
        let model: OpenAIModelType = .gpt3_5(.gpt_3_5_turbo_1106)
        let optionalParameters: CompletionsOptionalParameters = .init(prompt: "Say this is a test",
                                                                      maxTokens: 1024,
                                                                      temperature: 0.8)
        let sut = OpenAIEndpoints.completions(model: model, optionalParameters: optionalParameters).endpoint
        
        let modelParameter = sut.parameters!["model"] as! String
        let promptParameter = sut.parameters!["prompt"] as! String
        let maxTokensParameter = sut.parameters!["max_tokens"] as! Int
        let temperatureParameter = sut.parameters!["temperature"] as! Double
        
        XCTAssertEqual(sut.path, "completions")
        XCTAssertEqual(sut.method, .POST)
        XCTAssertEqual(sut.parameters?.count, 14)
        XCTAssertEqual(modelParameter, model.name)
        XCTAssertEqual(promptParameter, optionalParameters.prompt)
        XCTAssertEqual(maxTokensParameter, optionalParameters.maxTokens)
        XCTAssertEqual(temperatureParameter, optionalParameters.temperature)
    }
}

