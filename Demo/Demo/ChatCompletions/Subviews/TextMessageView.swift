import SwiftUI
import SwiftOpenAI

struct TextMessageView: View {
    var message: MessageChatGPT
    
    var body: some View {
        HStack {
            if message.role == .user {
                Spacer()
                Text(message.text)
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(.white)
                    .padding(.all, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.blue)
                    )
                    .frame(maxWidth: 240, alignment: .trailing)
                    .id(message.id)
            } else if message.role == .assistant || message.role == .system {
                if message.text == "" {
                    TypingIndicatorView()
                        .padding(.all, 10)
                } else {
                    Text(message.text)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(.white)
                        .padding(.all, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.gray)
                        )
                        .frame(maxWidth: 240, alignment: .leading)
                        .id(message.id)
                }
                Spacer()
            } else {
                EmptyView()
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    TextMessageView(message: .init(text: "Hello! my name is SwiftBeta", role: .user))
}
