import SwiftOpenAI
import Foundation
import Observation

@Observable
final class CreateImageViewModel {
    private let openAI = SwiftOpenAI(apiKey: Bundle.main.getOpenAIApiKey()!)
    var imageURLStrings: [String] = []
    var isLoading: Bool = false
    
    @MainActor
    func createImages(prompt: String) async {
        imageURLStrings = []
        isLoading = true
        do {
            guard let images = try await openAI.createImages(model: .dalle(.dalle3),
                                                             prompt: prompt,
                                                             numberOfImages: 1,
                                                             size: .sw1024h1792) else {
                isLoading = false
                return
            }
            imageURLStrings =  images.data.map { $0.url }
            isLoading = false
        } catch {
            isLoading = false
            print("Error creating Images with DALL·E: ", error.localizedDescription)
        }
    }
}
