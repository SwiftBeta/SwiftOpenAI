import Foundation
import SwiftOpenAI

@Observable
final class VisionViewModel {
    var openAI = SwiftOpenAI(apiKey: Bundle.main.getOpenAIApiKey()!)
    let imageVisionURL = "https://upload.wikimedia.org/wikipedia/commons/thumb/5/57/M31bobo.jpg/640px-M31bobo.jpg"
    var message: String = ""
    var isLoading = false
    
    @MainActor
    func send(message: String) async {
        isLoading = true

        do {
            let myMessage = MessageChatImageInput(text: message,
                                                  imageURL: imageVisionURL,
                                                  role: .user)
                                    
            let optionalParameters: ChatCompletionsOptionalParameters = .init(temperature: 0.5, 
                                                                              stop: ["stopstring"],
                                                                              stream: false,
                                                                              maxTokens: 1200)
            
            let result = try await openAI.createChatCompletionsWithImageInput(model: .gpt4(.gpt_4_vision_preview),
                                                                                             messages: [myMessage],
                                                                                             optionalParameters: optionalParameters)
            
            self.message = result?.choices.first?.message.content ?? "No value"
            self.isLoading = false
            
        } catch {
            print("Error trying to understant the image you provided: ", error.localizedDescription)
        }
    }
}
