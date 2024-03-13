import SwiftUI
import PhotosUI

struct VisionView: View {
    @State private var visionStrategy = 0
    @State var viewModel: VisionViewModel
    
    var body: some View {
        VStack {
            Picker("What is your favorite color?", selection: $visionStrategy) {
                Text("URL").tag(0)
                Text("Gallery").tag(1)
            }
            .pickerStyle(.segmented)
            
            if visionStrategy == 0 {
                AsyncImage(url: URL(string: viewModel.imageVisionURL)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                } placeholder: {
                    ProgressView()
                        .padding(.bottom, 20)
                }
            } else {
                PhotosPicker(selection: $viewModel.photoSelection,
                             matching: .images,
                             photoLibrary: .shared()) {
                    Label("Add video or audio",
                          systemImage: "video.fill")
                }
                             .frame(height: 300)
                             .photosPickerStyle(.inline)
                             .onChange(of: viewModel.photoSelection!) { oldValue, newValue in
                                 newValue.loadTransferable(type: Data.self) { [self] result in
                                     switch result {
                                     case .success(let data):
                                         if let data {
                                             viewModel.currentData = data
                                         } else {
                                             print("No supported content type found.")
                                         }
                                     case .failure(let error):
                                         fatalError(error.localizedDescription)
                                     }
                                 }
                             }
            }
            
            if !viewModel.isLoading {
                Button(action: {
                    Task {
                        await viewModel.send(message: "Please analyze the image and describe its contents, providing any relevant details or information")
                    }
                }, label: {
                    Text("Describe Image from URL")
                })
                .buttonStyle(.borderedProminent)
            } else {
                ProgressView()
            }
            
            Divider()
                .padding(.top, 20)
            
            TextEditor(text: .constant(viewModel.message))
                .font(.body)
                .padding(.top, 12)
                .padding(.horizontal)
        }
        .padding(.horizontal, 32)
    }
}

#Preview {
    VisionView(viewModel: .init())
}
