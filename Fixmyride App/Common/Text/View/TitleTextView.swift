import SwiftUI

struct TitleTextView: View {
    var text: String
    var foregroundColor: Color = Color.black
    var body: some View {
        Text(text)
            .font(.largeTitle)
            .fontWeight(.heavy)
            .foregroundColor(foregroundColor)
    }
}

#Preview {
    TitleTextView(text: "car")
}

