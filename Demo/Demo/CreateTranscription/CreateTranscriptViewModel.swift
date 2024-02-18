import Foundation
import SwiftUI
import PhotosUI
import SwiftOpenAI

@Observable
class CreateTranscriptViewModel {
    var openAI = SwiftOpenAI(apiKey: Bundle.main.getOpenAIApiKey()!)
    
    var photoSelection: PhotosPickerItem? = .init(itemIdentifier: "")
    var transcription: String = ""
    var isLoading: Bool = false
    
    var currentData: Data?
    
    func createTranscription() async {
        guard let data = currentData else {
            print("Error: Data is empty")
            return
        }
        
        isLoading = true
        let model: OpenAITranscriptionModelType = .whisper
        
        do {
            for try await newMessage in try await openAI.createTranscription(model: model,
                                                                            file: data,
                                                                            language: "en",
                                                                            prompt: "",
                                                                            responseFormat: .mp3,
                                                                            temperature: 1.0) {
                print("Received Transcription \(newMessage)")
                await MainActor.run {
                    isLoading = false
                    transcription = newMessage.text
                }
            }
        } catch {
            print("Error creating Transcription from file: ", error.localizedDescription)
        }
    }
}
