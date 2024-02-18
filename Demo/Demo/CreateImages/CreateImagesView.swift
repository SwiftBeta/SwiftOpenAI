import SwiftUI

struct CreateImagesView: View {
    var viewModel: CreateImageViewModel

    @State var prompt: String = "Create a highly detailed and realistic image capturing a moment of profound innovation and determination. Imagine a scene set in the early 2000s within a minimalist yet intensely focused work environment. In the center, a figure with a striking resemblance to a generic tech visionary, embodying the spirit and physicality of an era-defining entrepreneur, but not directly imitating Steve Jobs, is intensely focused on a sleek, yet-to-be-revealed device in his hands. This device, with its clean lines and revolutionary design, hints at being the first iPhone, marking the dawn of a new era in technology. The background is filled with sketches and prototypes, reflecting the culmination of years of design and innovation. The lighting is soft yet purposeful, highlighting the anticipation and the moment of breakthrough. This scene is not just about the creation of a device but the birth of a vision that would change the world"
    
    var body: some View {
        VStack {
            Grid {
                if viewModel.imageURLStrings.isEmpty {
                    VStack {
                        Image(systemName: "photo.stack")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120)
                        if viewModel.isLoading {
                            LoadingView()
                        } else {
                            Text("Add the prompt or description in the bottom text field of the image you wish to create")
                                .font(.system(size: 24))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)
                        }
                    }
                    .font(.system(size: 24))
                    .padding(.top, 60)
                }
                
                if !viewModel.imageURLStrings.isEmpty {
                    ForEach(viewModel.imageURLStrings, id: \.self) { imageURL in
                        GridRow {
                            AsyncImage(url: URL(string: imageURL)) { image in
                                image
                                    .resizable()
                                    .scaledToFit()
                            } placeholder: {
                                ProgressView()
                            }
                        }
                    }
                }
            }
            Spacer()
            HStack {
                TextField("Write something for DALL·E", text: $prompt, axis: .vertical)
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(25)
                    .lineLimit(6)
                    .onSubmit {
                        Task {
                            await viewModel.createImages(prompt: prompt)
                            prompt = ""
                        }
                    }
                Button(action: {
                    Task {
                        await viewModel.createImages(prompt: prompt)
                        prompt = ""
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
    CreateImagesView(viewModel: .init())
}
