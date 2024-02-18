import Foundation
import SwiftOpenAI
import AVFoundation

@Observable
final class CreateAudioViewModel: NSObject {
    var openAI = SwiftOpenAI(apiKey: Bundle.main.getOpenAIApiKey()!)
    var avAudioPlayer = AVAudioPlayer()
    var isLoadingTextToSpeechAudio: TextToSpeechType = .noExecuted
    
    enum TextToSpeechType {
        case noExecuted
        case isLoading
        case finishedLoading
        case finishedPlaying
    }
    
    func playAudioAgain() {
        avAudioPlayer.play()
    }
    
    @MainActor
    func createSpeech(input: String) async {
        isLoadingTextToSpeechAudio = .isLoading
        do {
            let data = try await openAI.createSpeech(model: .tts(.tts1),
                                                     input: input,
                                                     voice: .alloy,
                                                     responseFormat: .mp3,
                                                     speed: 1.0)

            if let filePath = FileManager.default.urls(for: .documentDirectory, 
                                                       in: .userDomainMask).first?.appendingPathComponent("speech.mp3"), 
                let data {
                do {
                    try data.write(to: filePath)
                    print("File created: \(filePath)")
                    
                    avAudioPlayer = try AVAudioPlayer(contentsOf: filePath)
                    avAudioPlayer.delegate = self
                    avAudioPlayer.play()
                    isLoadingTextToSpeechAudio = .finishedLoading
                } catch {
                    print("Error saving file: ", error.localizedDescription)
                }
            } else {
                print("Error trying to save file in filePath")
            }
            
        } catch {
            print("Error creating Audios: ", error.localizedDescription)
        }
    }
}

extension CreateAudioViewModel: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        isLoadingTextToSpeechAudio = .finishedPlaying
    }
}
