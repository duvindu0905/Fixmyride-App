import SwiftUI

struct FootnoteTextView: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.footnote)
            .fontWeight(.medium)
            .foregroundColor(Color("commonTextColor"))
    }
}

#Preview {
    FootnoteTextView(text: "Car")
}

