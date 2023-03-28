import XCTest
@testable import SwiftOpenAI

final class CreateImageParserSpec: XCTestCase {
    private var api = API()
    
    func testAsyncAPIRequest_ParsesValidJSONToChatCompletionsDataModel() async throws {
        let jsonData = loadJSON(name: "create.image")
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let dataModel = try! api.parse(.success(jsonData), type: CreateImageDataModel.self, jsonDecoder: jsonDecoder, errorType: OpenAIAPIError.self)
        
        XCTAssertNotNil(dataModel)
        XCTAssertEqual(dataModel?.created, 1589478378)
        XCTAssertEqual(dataModel?.data.count, 4)
        XCTAssertEqual(dataModel?.data[0].url, "https://www.openai1.com")
        XCTAssertEqual(dataModel?.data[1].url, "https://www.openai2.com")
        XCTAssertEqual(dataModel?.data[2].url, "https://www.openai3.com")
        XCTAssertEqual(dataModel?.data[3].url, "https://www.openai4.com")
    }
}
