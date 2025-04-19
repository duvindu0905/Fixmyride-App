import SwiftUI

struct CommonEventCardView: View {
    var title: String = ""
    var day: String = ""
    var imageUrl: String = ""

    var body: some View {
        ZStack {
            // Background image
            AsyncImage(url: URL(string: imageUrl)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(1, contentMode: .fill)
                        .frame(height: 150)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .clipped()
                } else {
                    Color.gray.opacity(0.3)
                        .frame(height: 150)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .overlay(ProgressView())
                }
            }

            // ⬇️ Black gradient behind text to increase readability
            LinearGradient(
                gradient: Gradient(colors: [.black.opacity(0.8), .clear]),
                startPoint: .bottom,
                endPoint: .top
            )
            .clipShape(RoundedRectangle(cornerRadius: 15))

            // ⬇️ White text
            VStack(alignment: .leading, spacing: 8) {
                Spacer()
                Text(title)
                    .foregroundColor(.white)
                    .font(.headline)
                    .bold()

                Text(day)
                    .foregroundColor(.white)
                    .font(.subheadline)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(height: 150)
    }
}


#Preview {
    CommonEventCardView()
}
