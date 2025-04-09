import SwiftUI

struct SecondaryHeadingTextView: View {
    var text: String
    var foregroundColor: Color = Color.black
    var weight: Font.Weight = .bold
    var font: Font = .title2
    var body: some View {
        Text(text)
            .font(font)
            .fontWeight(weight)
            .foregroundColor(foregroundColor)
    }
}

#Preview {
    SecondaryHeadingTextView(text: "jfklasd")
}

