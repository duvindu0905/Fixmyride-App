import SwiftUI

struct CommonEventCardView: View {
    var title: String = ""
    var day: String = ""
    var imageUrl: String = ""
    var body: some View {
        ZStack {
            AsyncImage(
                url: URL(string: imageUrl)
            ) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .aspectRatio(
                            1, contentMode: .fill
                        )
                        .frame(height: 150)
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: 15)
                        )
                        .clipped()
                } else {
                    ProgressView()
                        .frame(width: 100, height: 100)
                }
            }

            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Spacer()
                    NormalTextView(
                        text: title,
                        foregroundColor: .white,
                        weight: .bold
                    )
                    NormalTextView(
                        text: day,
                        foregroundColor: .white
                    )
                }
                .padding(16)
                Spacer()
            }
        }
    }
}

#Preview {
    CommonEventCardView()
}

