import SwiftUI

struct CommonAnnotationView: View {
    var backgroundColor: Color = Color("brandColor")
    var icon: String = "building.fill"
    var body: some View {
        Image(systemName: icon)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(.white)
            .frame(
                width: UIScreen.main.bounds.width * 0.05,
                height: UIScreen.main.bounds.width * 0.05
            )
            .padding(7)
            .background(backgroundColor.gradient, in: .circle)
    }
}

#Preview {
    CommonAnnotationView()
}

