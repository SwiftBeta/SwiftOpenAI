import SwiftUI

struct ConversationView: View {
    @State var bottomPadding: Double = 160
    @Binding var viewModel: ChatCompletionsViewModel
    
    var body: some View {
        ScrollViewReader { scrollProxy in
            ScrollView {
                ForEach(viewModel.messages) { message in
                    TextMessageView(message: message)
                        .padding(.bottom, viewModel.messages.last == message ? bottomPadding : 0)
                }
            }
            .scrollIndicators(.hidden)
            .onChange(of: viewModel.currentMessage, { _, newMessage in
                withAnimation(.linear(duration: 0.5)) {
                    scrollProxy.scrollTo(newMessage.id, anchor: .bottom)
                }
            })
            .onAppear {
                withAnimation {
                    scrollProxy.scrollTo(viewModel.messages.last?.id)
                }
            }
        }
    }
}

#Preview {
    ConversationView(viewModel: .constant(.init()))
}
