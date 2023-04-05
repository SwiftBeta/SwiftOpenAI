import XCTest
@testable import SwiftOpenAI

final class EditsParserSpec: XCTestCase {
    private var api = API()
    
    func testAsyncAPIRequest_ParsesValidJSONToEditsDataModel() async throws {
        let jsonData = loadJSON(name: "edits")
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let dataModel = try! api.parse(.success(jsonData), type: EditsDataModel.self, jsonDecoder: jsonDecoder, errorType: OpenAIAPIError.self)
        
        XCTAssertNotNil(dataModel)
        XCTAssertEqual(dataModel?.object, "edit")
        XCTAssertEqual(dataModel?.created, 1589478378)
        XCTAssertEqual(dataModel?.choices[0].index, 0)
        XCTAssertEqual(dataModel?.choices[0].text, "What day of the week is it?")
        XCTAssertEqual(dataModel?.usage.promptTokens, 25)
        XCTAssertEqual(dataModel?.usage.completionTokens, 32)
        XCTAssertEqual(dataModel?.usage.totalTokens, 57)
    }
}
