import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemGray5))
                .frame(width: 350, height: 100)
                .overlay {
                    Text("Generating image, please wait a few seconds...")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.primary)
                        .padding(.horizontal)
                }
        }
    }
}

#Preview {
    LoadingView()
}
