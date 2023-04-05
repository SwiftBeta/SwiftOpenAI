import XCTest
@testable import SwiftOpenAI

final class CompletionParserSpec: XCTestCase {
    private var api = API()
    
    func testAsyncAPIRequest_ParsesValidJSONToCompletionsDataModel() async throws {
        let jsonData = loadJSON(name: "completions")
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let dataModel = try! api.parse(.success(jsonData), type: CompletionsDataModel.self, jsonDecoder: jsonDecoder, errorType: OpenAIAPIError.self)
        
        XCTAssertNotNil(dataModel)
        XCTAssertEqual(dataModel?.id, "cmpl-uqkvlQyYK7bGYrRHQ0eXlWi7")
        XCTAssertEqual(dataModel?.object, "text_completion")
        XCTAssertEqual(dataModel?.created, 1589478378)
        XCTAssertEqual(dataModel?.choices.count, 1)
        XCTAssertEqual(dataModel?.choices[0].index, 0)
        XCTAssertEqual(dataModel?.choices[0].text, "\n\nThis is indeed a test")
        XCTAssertEqual(dataModel?.choices[0].index, 0)
        XCTAssertEqual(dataModel?.choices[0].finishReason, "length")
        XCTAssertEqual(dataModel?.usage.promptTokens, 5)
        XCTAssertEqual(dataModel?.usage.completionTokens, 7)
        XCTAssertEqual(dataModel?.usage.totalTokens, 12)
    }
}
