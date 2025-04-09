import SwiftUI

struct HeadingTextView: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(Color.black)
    }
}

#Preview {
    HeadingTextView(text: "Sample text")
}

