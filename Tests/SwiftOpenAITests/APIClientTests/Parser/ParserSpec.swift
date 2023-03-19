import XCTest
@testable import SwiftOpenAI

class ParserSpec: XCTestCase {
    
    func testParser_WhenCorrectJSONisMappedIntoAModel_ShouldHaveCorrectValuesInProperties() throws {
        // Arrange
        let data = """
            {
                "user": "SwiftBeta",
                "number_of_videos": 140,
                "topics": ["SwiftUI", "Swift", "Xcode", "Testing", "Combine"],
            }
        """.data(using: .utf8)!
        
        // Act
        let sut = try Parser().parse(data, type: SwiftBetaModel.self, jsonDecoder: .init())
        
        // Assert
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut?.user, "SwiftBeta")
        XCTAssertEqual(sut?.numberOfVideos, 140)
        XCTAssertEqual(sut?.topics, ["SwiftUI", "Swift", "Xcode", "Testing", "Combine"])
    }
    
    func testParser_WhenKeyNotFoundInJSON_ShouldThrowsAndException() throws {
        let data = """
            {
                "user": "SwiftBeta",
                "number_ofvideos": 140
            }
        """.data(using: .utf8)!
            
        XCTAssertThrowsError(try Parser().parse(data, type: SwiftBetaModel.self, jsonDecoder: .init()), "JSON Key Not Found") { error in
            XCTAssertTrue(error is APIError)
        }
    }
    
    func testParser_WhenMismatchTypeInJSON_ShouldThrowsAndException() throws {
        let data = """
            {
                "user": "SwiftBeta",
                "number_of_videos": "140",
                "topics": ["SwiftUI", "Swift", "Xcode", "Testing", "Combine"],
            }
        """.data(using: .utf8)!
                
        XCTAssertThrowsError(try Parser().parse(data, type: SwiftBetaModel.self, jsonDecoder: .init()), "JSON Type Mismatch") { error in
            XCTAssertTrue(error is APIError)
        }
    }
}
