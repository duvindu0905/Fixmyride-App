import SwiftUI

struct CommonIconButtonView: View {
    @State var icon: String
    var body: some View {
        Image(systemName: icon)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(.black)
            .frame(
                width: UIScreen.main.bounds.width * 0.03,
                height: UIScreen.main.bounds.width * 0.03
            )
            .padding(10)
            .background(Color("inputBackground"), in: .circle)
    }
}

#Preview {
    CommonIconButtonView(icon: "xmark")
}

