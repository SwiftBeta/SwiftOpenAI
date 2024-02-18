import SwiftUI

struct VisionView: View {
    var viewModel: VisionViewModel
    
    var body: some View {
        VStack {
            AsyncImage(url: URL(string: viewModel.imageVisionURL)) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)
            } placeholder: {
                ProgressView()
            }
            
            if !viewModel.isLoading {
                Button(action: {
                    Task {
                        await viewModel.send(message: "Please analyze the image and describe its contents, providing any relevant details or information")
                    }
                }, label: {
                    Text("Describe Image")
                })
                .buttonStyle(.borderedProminent)
            } else {
                ProgressView()
            }
            
            TextEditor(text: .constant( viewModel.message))
                .font(.body)
                .padding(.top, 12)
                .padding(.horizontal)
        }
    }
}

#Preview {
    VisionView(viewModel: .init())
}
