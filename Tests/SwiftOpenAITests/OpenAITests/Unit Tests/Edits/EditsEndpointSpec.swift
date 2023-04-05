import XCTest
@testable import SwiftOpenAI

final class EditsEndpointSpec: XCTestCase {
    func testEndpointCompletions_WithDavinciModelInputAndInstruction_CreatesCorrectEndpointParameters() throws {
        let model: OpenAIModelType = .edit(.text_davinci_edit_001)
        let input = "What day of the wek is it?"
        let instructions = "Fix the spelling mistakes"
        
        let sut = OpenAIEndpoints.edits(model: model, input: input, instruction: instructions).endpoint
        
        let modelParameter = sut.parameters!["model"] as! String
        let inputParameter = sut.parameters!["input"] as! String
        let instructionsParameter = sut.parameters!["instruction"] as! String
        
        XCTAssertEqual(sut.path, "edits")
        XCTAssertEqual(sut.method, .POST)
        XCTAssertEqual(sut.parameters?.count, 3)
        XCTAssertEqual(modelParameter, model.name)
        XCTAssertEqual(inputParameter, input)
        XCTAssertEqual(instructionsParameter, instructions)
    }
    
    func testEndpointCompletions_WithDavinciModelInput_WithoutInstruction_CreatesCorrectEndpointParameters() throws {
        let model: OpenAIModelType = .edit(.text_davinci_edit_001)
        let input = "What day of the wek is it?"
        
        let sut = OpenAIEndpoints.edits(model: model, input: input, instruction: "").endpoint
        
        let modelParameter = sut.parameters!["model"] as! String
        let inputParameter = sut.parameters!["input"] as! String
        let instructionsParameter = sut.parameters!["instruction"] as! String
        
        XCTAssertEqual(sut.path, "edits")
        XCTAssertEqual(sut.method, .POST)
        XCTAssertEqual(sut.parameters?.count, 3)
        XCTAssertEqual(modelParameter, model.name)
        XCTAssertEqual(inputParameter, input)
        XCTAssertEqual(instructionsParameter, "")
    }
}

