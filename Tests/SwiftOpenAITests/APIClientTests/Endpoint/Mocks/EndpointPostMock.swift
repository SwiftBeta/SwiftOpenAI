import Foundation
@testable import SwiftOpenAI

struct EndpointPostMock: Endpoint {
    private let parameterOne: String
    private let parameterTwo: String
    
    init(parameterOne: String,
         parameterTwo: String) {
        self.parameterOne = parameterOne
        self.parameterTwo = parameterTwo
    }
    
    var method: HTTPMethod {
        .POST
    }
    
    var path: String = "mock"
    
    var parameters: [String : Any]? {
        ["parameter_one": parameterOne as Any,
         "parameter_two": parameterTwo as Any]
    }
}

