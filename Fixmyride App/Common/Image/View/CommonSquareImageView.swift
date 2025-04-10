import SwiftUI

struct CommonSquareImageView: View {
    var url: String
    let imageSize = UIScreen.main.bounds.width / 2.3
    var body: some View {
        AsyncImage(url: URL(string: url)) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .aspectRatio(1, contentMode: .fill)
                    .frame(width: imageSize, height: imageSize)
                    .clipShape(
                        RoundedRectangle(
                            cornerRadius: 15)
                    )
                    .clipped()
            } else {
                ProgressView()
                    .frame(width: imageSize, height: imageSize)
            }
        }
    }
}

#Preview {
    CommonSquareImageView(
        url:
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSTe_zmaFqr8b5YgkW95vuB0Ac7TMHb8-zBGw&s"
    )
}

