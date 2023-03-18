import XCTest
@testable import SwiftOpenAI

class RouterSpec: XCTestCase {

    func testRequestBuilder_WhenURLRequestIsCreatedWithGETEndpointAndHeader_ShouldBeNotNil() throws {
        let sut = Router()
        var endpointMock: Endpoint = EndpointGetMock(parameterOne: "parameter_one_value", parameterTwo: "parameter_two_value")
        sut.routeEndpoint(&endpointMock, environment: BaseEnvironmentMock())
        
        XCTAssertEqual(endpointMock.path, "https://www.swiftbeta.com/mock")
    }

}
