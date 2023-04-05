import XCTest
@testable import SwiftOpenAI

final class ListModelsParserSpec: XCTestCase {
    private var api = API()
    
    func testAsyncAPIRequest_ParsesValidJSONToEditsDataModel() async throws {
        let jsonData = loadJSON(name: "models")
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let dataModel = try! api.parse(.success(jsonData), type: ModelListDataModel.self, jsonDecoder: jsonDecoder, errorType: OpenAIAPIError.self)
        
        XCTAssertNotNil(dataModel)
        XCTAssertEqual(dataModel?.data.count, 66)
        XCTAssertEqual(dataModel?.data[0].object, "model")
        XCTAssertEqual(dataModel?.data[0].id, "babbage")
        XCTAssertEqual(dataModel?.data[0].created, 1649358449)
        XCTAssertEqual(dataModel?.data[0].ownedBy, "openai")
    }
}
