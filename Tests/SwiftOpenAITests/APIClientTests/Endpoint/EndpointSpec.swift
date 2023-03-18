import XCTest

class EndpointSpec: XCTestCase {

    func testGetEndpoint_WhenIsInitialized_ShouldHaveCorrectValuesInProperties() throws {
        // Arrange
        let sut = EndpointGetMock(parameterOne: "SwiftBeta", parameterTwo: "Swift")
        // Act
        
        // Assert
        XCTAssertEqual(sut.path, "mock")
        XCTAssertEqual(sut.method, .GET)
        XCTAssertEqual(sut.parameters?.count, 2)
        XCTAssertEqual(sut.parameters as! [String : String], ["parameter_one": "SwiftBeta", "parameter_two": "Swift"])
    }
    
    func testPostEndpoint_WhenIsInitialized_ShouldHaveCorrectValuesInProperties() throws {
        // Arrange
        let sut = EndpointPostMock(parameterOne: "SwiftBeta", parameterTwo: "Swift")
        // Act
        
        // Assert
        XCTAssertEqual(sut.path, "mock")
        XCTAssertEqual(sut.method, .POST)
        XCTAssertEqual(sut.parameters?.count, 2)
        XCTAssertEqual(sut.parameters as! [String : String], ["parameter_one": "SwiftBeta", "parameter_two": "Swift"])
    }
    
    func testEmptyEndpoint_WhenIsInitialized_ShouldHaveCorrectValuesInProperties() throws {
        // Arrange
        let sut = EmptyEndpointMock()
        // Act
        
        // Assert
        XCTAssertEqual(sut.path, "mock")
        XCTAssertEqual(sut.method, .GET)
        XCTAssertNil(sut.parameters, "")
    }
}
