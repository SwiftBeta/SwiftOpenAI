import Foundation
import SwiftOpenAI
import PhotosUI
import SwiftUI

@Observable
final class VisionViewModel {
    var openAI = SwiftOpenAI(apiKey: Bundle.main.getOpenAIApiKey()!)
    let imageVisionURL = "https://upload.wikimedia.org/wikipedia/commons/thumb/5/57/M31bobo.jpg/640px-M31bobo.jpg"
    var message: String = ""
    var isLoading = false
    
    // Local Image
    var photoSelection: PhotosPickerItem? = .init(itemIdentifier: "")
    var currentData: Data?
    
    @MainActor
    func send(message: String) async {
        isLoading = true

        do {
            let imageValue: String
            if let data = currentData {
                let base64Image = data.base64EncodedString()
                imageValue = "data:image/jpeg;base64,\(base64Image)"
            } else {
                imageValue = imageVisionURL
            }
            
            let myMessage = MessageChatImageInput(text: message,
                                                  imageURL: imageValue,
                                                  role: .user)
                                    
            let optionalParameters: ChatCompletionsOptionalParameters = .init(temperature: 0.5, 
                                                                              stop: ["stopstring"],
                                                                              stream: false,
                                                                              maxTokens: 1200)
            
            let result = try await openAI.createChatCompletionsWithImageInput(model: .gpt4(.gpt_4_vision_preview),
                                                                                             messages: [myMessage],
                                                                                             optionalParameters: optionalParameters)
            self.currentData = nil
            self.message = result?.choices.first?.message.content ?? "No value"
            self.isLoading = false
            
        } catch {
            print("Error trying to understant the image you provided: ", error.localizedDescription)
        }
    }
}
