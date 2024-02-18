import SwiftUI
import AVKit

struct CreateAudioView: View {
    var viewModel: CreateAudioViewModel
    @State var prompt: String = "Hello, I'm SwiftBeta, a developer who in his free time tries to teach through his blog swiftbeta.com and his YouTube channel. Now I'm adding the OpenAI API to transform this text into audio"
    
    var body: some View {
        VStack {
            VStack {
                switch viewModel.isLoadingTextToSpeechAudio {
                case .isLoading:
                    TypingIndicatorView()
                        .padding(.top, 60)
                case .noExecuted:
                    VStack {
                        Image(systemName: "waveform")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                        Text("Add the prompt in the bottom text field of the audio you wish to create")
                            .font(.system(size: 24))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }
                    .font(.system(size: 24))
                    .padding(.top, 60)
                case .finishedPlaying, 
                        .finishedLoading:
                    VStack {
                        Image(systemName: "waveform")
                            .font(.system(size: 120))
                        Button {
                            viewModel.playAudioAgain()
                        } label: {
                            Text("Tap to play it again!")
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding(.top, 60)
                }
            }
            .padding(.horizontal, 32)
            
            Spacer()
            
            HStack {
                TextField("Write something to create Speech", text: $prompt, axis: .vertical)
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(25)
                    .lineLimit(6)
                    .onSubmit {
                        Task {
                            await viewModel.createSpeech(input: prompt)
                        }
                    }
                Button(action: {
                    Task {
                        await viewModel.createSpeech(input: prompt)
                    }
                }) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(Color.white)
                        .frame(width: 44, height: 44)
                        .background(Color.blue)
                        .cornerRadius(22)
                }
                .padding(.leading, 8)
            }
            .padding(.horizontal)
        }
        .padding(.top)
    }
}

#Preview {
    CreateAudioView(viewModel: .init())
}
