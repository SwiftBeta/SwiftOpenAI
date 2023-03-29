import XCTest
@testable import SwiftOpenAI

final class ChatCompletionStreamAPIClientSpec: XCTestCase {
    private var sut: CreateChatCompletionsStreamRequestProtocol & URLSessionDelegate = CreateChatCompletionsStreamRequest()
    private let model: OpenAIModelType = .gpt4(.base)
    private let apiKey = "1234567890"
    private let optionalParameters: ChatCompletionsOptionalParameters = .init(stream: true)
    private let messages: [MessageChatGPT] = [.init(text: "Hello, who are you?",
                                                    role: .user)]
    
    func testAsyncAPIRequest_ParsesValidJSONToChatCompletionsDataModel() async throws {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLStreamProtocolMock.self]
        
        var requesterStreamMock = RequesterMock()
        requesterStreamMock.urlSession = URLSession(configuration: configuration, delegate: sut, delegateQueue: OperationQueue())
        let api = API(requester: requesterStreamMock)
        
        sut.setURLSession(urlSession: requesterStreamMock.urlSession)
        
        let stringResult = "data: {\"id\":\"chatcmpl-6y3hLScC8nkFaGwfZWXqBXPPFdlei\",\"object\":\"chat.completion.chunk\",\"created\":1679771915,\"model\":\"gpt-3.5-turbo-0301\",\"choices\":[{\"delta\":{\"content\":\" conectar\"},\"index\":0,\"finish_reason\":null}]}\n\ndata: {\"id\":\"chatcmpl-6y3hLScC8nkFaGwfZWXqBXPPFdlei\",\"object\":\"chat.completion.chunk\",\"created\":1679771915,\"model\":\"gpt-3.5-turbo-0301\",\"choices\":[{\"delta\":{\"content\":\" emoc\"},\"index\":0,\"finish_reason\":null}]}\n\n"
        
        let responseData = stringResult.data(using: .utf8)!
        let response = HTTPURLResponse()
        
        URLStreamProtocolMock.response = (responseData, response, nil)
        
        do {
            var streamOfMessages: [ChatCompletionsStreamDataModel] = []
            for try await newMessage in try sut.execute(api: api, apiKey: apiKey, model: model, messages: messages, optionalParameters: optionalParameters) {
                streamOfMessages.append(newMessage)
            }
            let firstStreamMessage = streamOfMessages[0]
            let secondStreamMessage = streamOfMessages[1]
            
            XCTAssertEqual(streamOfMessages.count, 2)
            XCTAssertEqual(firstStreamMessage.id, "chatcmpl-6y3hLScC8nkFaGwfZWXqBXPPFdlei")
            XCTAssertEqual(firstStreamMessage.object, "chat.completion.chunk")
            XCTAssertEqual(firstStreamMessage.model, "gpt-3.5-turbo-0301")
            XCTAssertEqual(firstStreamMessage.choices[0].delta?.content, " conectar")
            XCTAssertEqual(firstStreamMessage.choices[0].index, 0)
            XCTAssertNil(firstStreamMessage.choices[0].finishReason)
            
            XCTAssertEqual(secondStreamMessage.id, "chatcmpl-6y3hLScC8nkFaGwfZWXqBXPPFdlei")
            XCTAssertEqual(secondStreamMessage.object, "chat.completion.chunk")
            XCTAssertEqual(secondStreamMessage.model, "gpt-3.5-turbo-0301")
            XCTAssertEqual(secondStreamMessage.choices[0].delta?.content, " emoc")
            XCTAssertEqual(secondStreamMessage.choices[0].index, 0)
            XCTAssertNil(secondStreamMessage.choices[0].finishReason)
        } catch {
            XCTFail()
        }
    }
    
    func testAsyncAPIRequest_ParsesValidErrorJSONToErrorDataModel() async throws {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLStreamProtocolMock.self]
        
        var requesterStreamMock = RequesterMock()
        requesterStreamMock.urlSession = URLSession(configuration: configuration, delegate: sut, delegateQueue: OperationQueue())
        let api = API(requester: requesterStreamMock)
        
        sut.setURLSession(urlSession: requesterStreamMock.urlSession)
        
        let stringResult = "dataaa: {\"id\":\"chatcmpl-6y3hLScC8nkFaGwfZWXqBXPPFdlei\",\"object\":\"chat.completion.chunk\",\"created\":1679771915,\"model\":\"gpt-3.5-turbo-0301\",\"choices\":[{\"delta\":{\"content\":\" conectar\"},\"index\":0,\"finish_reason\":null}]}\n\ndata: {\"id\":\"chatcmpl-6y3hLScC8nkFaGwfZWXqBXPPFdlei\",\"object\":\"chat.completion.chunk\",\"created\":1679771915,\"model\":\"gpt-3.5-turbo-0301\",\"choices\":[{\"delta\":{\"content\":\" emoc\"},\"index\":0,\"finish_reason\":null}]}\n\n"
        
        let responseData = stringResult.data(using: .utf8)!
        let response = HTTPURLResponse()
        
        URLStreamProtocolMock.response = (responseData, response, nil)
        
        do {
            var streamOfMessages: [ChatCompletionsStreamDataModel] = []
            for try await newMessage in try sut.execute(api: api, apiKey: apiKey, model: model, messages: messages, optionalParameters: optionalParameters) {
                streamOfMessages.append(newMessage)
            }
            XCTFail()
        } catch let error as DecodingError {
            switch error{
            case .dataCorrupted(let context):
                XCTAssertEqual(context.debugDescription, "The given data was not valid JSON.")
            default:
                XCTFail()
            }
        }
    }
}
