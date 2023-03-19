import XCTest
@testable import SwiftOpenAI

class RequesterSpec: XCTestCase {
    
    struct MyTestError: Error, Decodable {
        
    }

    func testSuccessfulRequestAndParsingOfSwiftBetaModel() async throws {
        let data =
        """
        {
            "user": "SwiftBeta",
            "number_of_videos": 140,
            "topics": ["SwiftUI", "Swift", "Xcode", "Testing", "Combine"],
        }
        """.data(using: .utf8)!
        
        let router = Router()
        let requestBuilder = RequestBuilder()
        var endpointMock: Endpoint = EndpointGetMock(parameterOne: "parameter_one_value",
                                                     parameterTwo: "parameter_two_value")
        router.routeEndpoint(&endpointMock, environment: BaseEnvironmentMock())
        var urlRequest = requestBuilder.buildURLRequest(endpoint: endpointMock)
        requestBuilder.addHeaders(urlRequest: &urlRequest, headers: ["Content-Type": "application/json",
                                                                     "Client-Id": "12345",
                                                                     "Authorization": "Bearer qwertyuiop"])
        
        URLProtocolMock.completionHandler = { request in
            let response = HTTPURLResponse(url: URL(string: endpointMock.path)!, statusCode: 200, httpVersion: nil, headerFields: [:])!
            return (response, data)
        }
                
        let requester = RequesterMock()
        let result = await requester.execute(with: urlRequest)
        
        let parser = Parser()
        
        let model = try parser.parse(result, type: SwiftBetaModel.self, errorType: MyTestError.self)
        
        XCTAssertNotNil(model)
        XCTAssertEqual(model?.user, "SwiftBeta")
        XCTAssertEqual(model?.numberOfVideos, 140)
        XCTAssertEqual(model?.topics, ["SwiftUI", "Swift", "Xcode", "Testing", "Combine"])
    }
}
