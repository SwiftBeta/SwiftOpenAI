import SwiftOpenAI
import Foundation
import Observation

@Observable
final class ChatCompletionsViewModel {
    private let openAI = SwiftOpenAI(apiKey: Bundle.main.getOpenAIApiKey()!)
    var messages: [MessageChatGPT] = [.init(text: "I am an AI and I am here to help you.", role: .system)]
    var currentMessage: MessageChatGPT = .init(text: "", role: .assistant)
    var isStream: Bool = true
    
    @MainActor
    func send(message: String) async {
        let myMessage = MessageChatGPT(text: message, 
                                       role: .user)
        messages.append(myMessage)
        currentMessage = MessageChatGPT(text: "", 
                                        role: .assistant)
        messages.append(currentMessage)
        
        let optionalParameters = ChatCompletionsOptionalParameters(temperature: 0.5,
                                                                   stream: isStream,
                                                                   maxTokens: 100)
        if isStream {
            do {
                for try await newMessage in try await openAI.createChatCompletionsStream(model: .gpt4(.base),
                                                                                         messages: messages,
                                                                                         optionalParameters: optionalParameters) {
                    onReceiveStream(newMessage: newMessage)
                }
            } catch {
                print("Error generating Chat Completion with STREAM: ", error.localizedDescription)
            }
        } else {
            do {
                let chatCompletions = try await openAI.createChatCompletions(
                    model: .gpt4(.base),
                    messages: messages,
                    optionalParameters: optionalParameters
                )
                
                chatCompletions.map {
                    onReceive(newMessage: $0)
                }
                
            } catch {
                print("Error generating Chat Completion: ", error.localizedDescription)
            }
        }
    }
    
    @MainActor
    private func onReceiveStream(newMessage: ChatCompletionsStreamDataModel) {
        guard let lastMessage = newMessage.choices.first,
              lastMessage.finishReason == nil,
              let content = lastMessage.delta?.content, !content.isEmpty else {
            return
        }
        
        currentMessage.text.append(content)
        if let lastIndex = messages.indices.last {
            messages[lastIndex].text = currentMessage.text
        }
    }
    
    @MainActor
    private func onReceive(newMessage: ChatCompletionsDataModel) {
        guard let lastMessage = newMessage.choices.first else {
            return
        }
        
        currentMessage.text.append(lastMessage.message.content)
        if let lastIndex = messages.indices.last {
            messages[lastIndex].text = currentMessage.text
        }
    }
}
