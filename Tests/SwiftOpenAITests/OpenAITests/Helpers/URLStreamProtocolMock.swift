import Foundation.NSURLSession
@testable import SwiftOpenAI

final class URLStreamProtocolMock: URLProtocol {
    static var response: (data: Data?, urlResponse: URLResponse?, error: Error?) = (nil, nil, nil)
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
    
    override func startLoading() {
        if let error = URLStreamProtocolMock.response.error {
            client?.urlProtocol(self, didFailWithError: error)
        } else {
            if let data = URLStreamProtocolMock.response.data {
                client?.urlProtocol(self, didLoad: data)
            }
            if let response = URLStreamProtocolMock.response.urlResponse {
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
        }
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() { }
}
