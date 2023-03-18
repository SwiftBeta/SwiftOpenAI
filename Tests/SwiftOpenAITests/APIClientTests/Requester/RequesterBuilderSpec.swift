import XCTest
@testable import SwiftOpenAI

class RequesterBuilderSpec: XCTestCase {

    func testRequestBuilder_WhenURLRequestIsCreatedWithGETEndpoint_ShouldBeNotNil() throws {
        let endpointMock = EndpointGetMock(parameterOne: "parameter_one_value", parameterTwo: "parameter_two_value")
        let requestBuilder = RequestBuilder()
        
        let sut = requestBuilder.buildURLRequest(endpoint: endpointMock)
        let absoluteStringURL = URLComponents(string: sut.url!.absoluteString)!
        let pathStringURL = sut.url!.path
        
        XCTAssertEqual(sut.httpMethod, "GET")
        XCTAssertNil(sut.httpBody)
        XCTAssertEqual(pathStringURL, "mock")
        XCTAssertTrue(absoluteStringURL.queryItems!.contains(where: { $0.name == "parameter_one"}))
        XCTAssertTrue(absoluteStringURL.queryItems!.contains(where: { $0.value == "parameter_one_value"}))
        XCTAssertTrue(absoluteStringURL.queryItems!.contains(where: { $0.name == "parameter_two"}))
        XCTAssertTrue(absoluteStringURL.queryItems!.contains(where: { $0.value == "parameter_two_value"}))
    }
    
    func testRequestBuilder_WhenURLRequestIsCreatedWithPOSTEndpoint_ShouldBeNotNil() throws {
        let endpointMock = EndpointPostMock(parameterOne: "parameter_one_value", parameterTwo: "parameter_two_value")
        let requestBuilder = RequestBuilder()
        
        let sut = requestBuilder.buildURLRequest(endpoint: endpointMock)
        let absoluteStringURL = URLComponents(string: sut.url!.absoluteString)!
        let pathStringURL = sut.url!.path
        
        XCTAssertEqual(sut.httpMethod, "POST")
        XCTAssertNotNil(sut.httpBody)
        XCTAssertEqual(pathStringURL, "mock")
        XCTAssertNil(absoluteStringURL.queryItems)
    }
    
    func testRequestBuilder_WhenURLRequestIsCreatedWithGETEndpointAndHeader_ShouldBeNotNil() throws {
        let endpointMock = EndpointGetMock(parameterOne: "parameter_one_value", parameterTwo: "parameter_two_value")
        let requestBuilder = RequestBuilder()
        var request = requestBuilder.buildURLRequest(endpoint: endpointMock)
        requestBuilder.addHeaders(urlRequest: &request, headers: ["token" : "swiftbeta", "Content-Type": "application/json"])
        
        let sut = request.allHTTPHeaderFields!
        XCTAssertTrue(sut.keys.contains(where: { $0 == "token"}))
        XCTAssertTrue(sut.keys.contains(where: { $0 == "Content-Type"}))
        XCTAssertEqual(sut["token"], "swiftbeta")
        XCTAssertEqual(sut["Content-Type"], "application/json")
    }
}
