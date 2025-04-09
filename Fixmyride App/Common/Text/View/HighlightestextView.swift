import SwiftUI

struct HighlightedTextView: View {
    var text: String
    var multilineTextAlignment: TextAlignment = .leading
    var body: some View {
        Text(text)
            .font(.callout)
            .fontWeight(.medium)
            .foregroundColor(Color("brandColor"))
            .multilineTextAlignment(multilineTextAlignment)
    }
}

#Preview {
    HighlightedTextView(text: "Sample")
}

