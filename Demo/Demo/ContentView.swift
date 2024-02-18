import SwiftUI
import SwiftOpenAI

struct ContentView: View {
    @State var chatCompletionsViewModel: ChatCompletionsViewModel = .init()
    @State var createImagesViewModel: CreateImageViewModel = .init()
    @State var createAudioViewModel: CreateAudioViewModel = .init()
    @State var createTranscriptViewModel: CreateTranscriptViewModel = .init()
    @State var visionViewModel: VisionViewModel = .init()
    
    var body: some View {
        TabView {
            NavigationStack {
                ChatView(viewModel: $chatCompletionsViewModel)
                    .navigationBarTitleDisplayMode(.large)
                    .navigationTitle("Conversations")
            }
            .tabItem {
                Label("Chat", systemImage: "message.fill")
            }
            NavigationStack {
                CreateImagesView(viewModel: createImagesViewModel)
                    .navigationBarTitleDisplayMode(.large)
                    .navigationTitle("Create Image")
            }
            .tabItem {
                Label("Create Image", systemImage: "photo.stack")
            }
            NavigationStack {
                CreateAudioView(viewModel: createAudioViewModel)
                    .navigationBarTitleDisplayMode(.large)
                    .navigationTitle("Create Audio")
            }
            .tabItem {
                Label("Create Audio", systemImage: "waveform")
            }
            NavigationStack {
                CreateTranscriptView(viewModel: $createTranscriptViewModel)
                    .navigationBarTitleDisplayMode(.large)
                    .navigationTitle("Transcript Audio")
            }
            .tabItem {
                Label("Transcript Audio", systemImage: "square.3.layers.3d.top.filled")
            }
            NavigationStack {
                VisionView(viewModel: visionViewModel)
                    .navigationBarTitleDisplayMode(.large)
                    .navigationTitle("Vision")
            }
            .tabItem {
                Label("Vision", systemImage: "eye")
            }
        }
    }
}

#Preview {
    ContentView()
}
