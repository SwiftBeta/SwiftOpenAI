import XCTest
@testable import SwiftOpenAI

final class CreateImageAPIClientSpec: XCTestCase {
    private var sut: CreateImagesRequestProtocol!
    private let prompt = "Pixar style 3D render of a baby hippo, 4k, high resolution, trending in artstation"
    private let numberOfImages = 4
    private let size: ImageSize = .s1024
    private let model: OpenAIModelType = .gpt4(.base)
    private let apiKey = "1234567890"
    
    func testAsyncAPIRequest_ParsesValidJSONToChatCompletionsDataModel() async throws {
        let json = loadJSON(name: "create.image")
        
        let api = API(requester: RequesterMock())
        
        let endpoint = OpenAIEndpoints.createImage(model: .dalle(.dalle3), prompt: prompt, numberOfImages: numberOfImages, size: size).endpoint
        
        sut = CreateImagesRequest()
        
        stubHTTP(endpoint: endpoint,
                 json: json,
                 statusCode: 200)
        
        do {
            let dataModel = try await sut.execute(api: api, apiKey: apiKey, model: .dalle(.dalle3), prompt: prompt, numberOfImages: numberOfImages, size: size)
            XCTAssertNotNil(dataModel)
            XCTAssertEqual(dataModel?.created, 1589478378)
            XCTAssertEqual(dataModel?.data.count, 4)
            XCTAssertEqual(dataModel?.data[0].url, "https://www.openai1.com")
            XCTAssertEqual(dataModel?.data[1].url, "https://www.openai2.com")
            XCTAssertEqual(dataModel?.data[2].url, "https://www.openai3.com")
            XCTAssertEqual(dataModel?.data[3].url, "https://www.openai4.com")
        } catch {
            XCTFail()
        }
    }
    
    private func stubHTTP(endpoint: Endpoint,
                          json: Data,
                          statusCode: Int) {
        
        URLProtocolMock.completionHandler = { request in
            let response = HTTPURLResponse(url: URL(string: endpoint.path)!,
                                           statusCode: statusCode,
                                           httpVersion: nil,
                                           headerFields: [:])!
            return (response, json)
        }
    }
}
