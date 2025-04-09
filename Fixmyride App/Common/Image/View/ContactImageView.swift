import SwiftUI

struct ContactImageView: View {
    var image: String = ""
    var body: some View {
        Image(image)
            .resizable()
            .scaledToFit()
            .frame(width: 150, height: 150)
    }
}

#Preview {
    ContactImageView()
}

