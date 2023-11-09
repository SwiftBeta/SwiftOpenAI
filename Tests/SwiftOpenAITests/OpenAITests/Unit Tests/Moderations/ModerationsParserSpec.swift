import XCTest
@testable import SwiftOpenAI

final class ModerationsParserSpec: XCTestCase {
    private var api = API()
    
    func testAsyncAPIRequest_ParsesValidJSONToModerationsDataModel() async throws {
        let jsonData = loadJSON(name: "moderations")
        
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let dataModel = try! api.parse(.success(jsonData), type: ModerationDataModel.self, jsonDecoder: jsonDecoder, errorType: OpenAIAPIError.self)
        
        XCTAssertNotNil(dataModel)
        XCTAssertEqual(dataModel?.id, "modr-5MWoLO")
        XCTAssertEqual(dataModel?.model, "text-moderation-001")
        XCTAssertEqual(dataModel?.results.count, 1)
        XCTAssertEqual(dataModel?.results[0].categories.hate, false)
        XCTAssertEqual(dataModel?.results[0].categories.hateThreatening, true)
        XCTAssertEqual(dataModel?.results[0].categories.selfHarm, false)
        XCTAssertEqual(dataModel?.results[0].categories.sexual, false)
        XCTAssertEqual(dataModel?.results[0].categories.sexualMinors, false)
        XCTAssertEqual(dataModel?.results[0].categories.violence, true)
        XCTAssertEqual(dataModel?.results[0].categories.violenceGraphic, false)
        XCTAssertEqual(dataModel?.results[0].categoryScores.hate, 0.22714105248451233)
        XCTAssertEqual(dataModel?.results[0].categoryScores.hateThreatening, 0.4132447838783264)
        //XCTAssertEqual(dataModel?.results[0].categoryScores.selfHarm, 0.005232391878962517, accuracy: 0.000000000000001)
        XCTAssertEqual(dataModel?.results[0].categoryScores.sexual, 0.01407341007143259)
        XCTAssertEqual(dataModel?.results[0].categoryScores.sexualMinors, 0.0038522258400917053)
        XCTAssertEqual(dataModel?.results[0].categoryScores.violence, 0.9223177433013916)
        XCTAssertEqual(dataModel?.results[0].categoryScores.violenceGraphic, 0.036865197122097015)
        XCTAssertEqual(dataModel?.results[0].flagged, true)
    }
}
