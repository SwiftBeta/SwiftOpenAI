import XCTest
@testable import SwiftOpenAI

final class ChatCompletionsStreamMapperSpec: XCTestCase {
    func dsaddsa() {
        let stringResult = "data: {\"id\":\"chatcmpl-6y3hLScC8nkFaGwfZWXqBXPPFdlei\",\"object\":\"chat.completion.chunk\",\"created\":1679771915,\"model\":\"gpt-3.5-turbo-0301\",\"choices\":[{\"delta\":{\"content\":\" conectar\"},\"index\":0,\"finish_reason\":null}]}\n\ndata: {\"id\":\"chatcmpl-6y3hLScC8nkFaGwfZWXqBXPPFdlei\",\"object\":\"chat.completion.chunk\",\"created\":1679771915,\"model\":\"gpt-3.5-turbo-0301\",\"choices\":[{\"delta\":{\"content\":\" emoc\"},\"index\":0,\"finish_reason\":null}]}\n\n"
        
        let sut = ChatCompletionsStreamMapper()
        do {
            let chatCompletionsStreamDataModel = try sut.parse(data: stringResult.data(using: .utf8)!)
            let firstStreamMessage = chatCompletionsStreamDataModel[0]
            let secondStreamMessage = chatCompletionsStreamDataModel[0]
            
            XCTAssertEqual(chatCompletionsStreamDataModel.count, 2)
            XCTAssertEqual(firstStreamMessage.id, "chatcmpl-6y3hLScC8nkFaGwfZWXqBXPPFdlei")
            XCTAssertEqual(firstStreamMessage.object, "chat.completion.chunk")
            XCTAssertEqual(firstStreamMessage.created, 1679771915)
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
}
