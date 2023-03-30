import XCTest
@testable import SwiftOpenAI

final class ChatCompletionsEndpointSpec: XCTestCase {    
    func testChatEndpointCreation_WithGPT4ModelAndMessages_CreatesCorrectEndpointParameters() throws {
        let model: OpenAIModelType = .gpt4(.base)
        let messages: [MessageChatGPT] = [.init(text: "Hello, who are you?", role: .user)]
        let sut = OpenAIEndpoints.chatCompletions(model: model, messages: messages, optionalParameters: nil).endpoint
        
        let firstParameterValue = sut.parameters!["model"] as! String
        let secondParameter = sut.parameters!["messages"] as! [[String : String]]
        
        XCTAssertEqual(sut.path, "chat/completions")
        XCTAssertEqual(sut.method, .POST)
        XCTAssertEqual(sut.parameters?.count, 8)
        XCTAssertEqual(firstParameterValue, model.name)
        XCTAssertEqual(secondParameter[0]["role"], messages[0].role.rawValue)
        XCTAssertEqual(secondParameter[0]["content"], messages[0].text)
    }
    
    func testChatEndpointCreation_WithGPT3_5ModelAndMessages_CreatesCorrectEndpointParameters() throws {
        let model: OpenAIModelType = .gpt3_5(.turbo)
        let messages: [MessageChatGPT] = [.init(text: "Generate 5 questions about Swift", role: .user)]
        let sut = OpenAIEndpoints.chatCompletions(model: model, messages: messages, optionalParameters: nil).endpoint
        
        let firstParameterValue = sut.parameters!["model"] as! String
        let secondParameter = sut.parameters!["messages"] as! [[String : String]]
        
        XCTAssertEqual(sut.path, "chat/completions")
        XCTAssertEqual(sut.method, .POST)
        XCTAssertEqual(sut.parameters?.count, 8)
        XCTAssertEqual(firstParameterValue, model.name)
        XCTAssertEqual(secondParameter[0]["role"], messages[0].role.rawValue)
        XCTAssertEqual(secondParameter[0]["content"], messages[0].text)
    }
    
    func testChatEndpointCreation_WithGPT4_ModelAndMessages_CreatesCorrectEndpointWithOptionalParameters() throws {
        let model: OpenAIModelType = .gpt3_5(.turbo)
        let messages: [MessageChatGPT] = [.init(text: "Generate 5 questions about Swift", role: .user)]
        let optionalParameters: ChatCompletionsOptionalParameters = .init(temperature: 0.5, stream: true)
        let sut = OpenAIEndpoints.chatCompletions(model: model, messages: messages, optionalParameters: optionalParameters).endpoint
        
        let firstParameterValue = sut.parameters!["model"] as! String
        let secondParameter = sut.parameters!["messages"] as! [[String : String]]
        
        XCTAssertEqual(sut.path, "chat/completions")
        XCTAssertEqual(sut.method, .POST)
        XCTAssertEqual(sut.parameters?.count, 8)
        XCTAssertEqual(sut.parameters?["temperature"] as! Double, 0.5)
        XCTAssertEqual(sut.parameters?["stream"] as! Bool, true)
        XCTAssertEqual(firstParameterValue, model.name)
        XCTAssertEqual(secondParameter[0]["role"], messages[0].role.rawValue)
        XCTAssertEqual(secondParameter[0]["content"], messages[0].text)
    }
}

