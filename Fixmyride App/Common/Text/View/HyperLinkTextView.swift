import SwiftUI

struct HyperLinkTextView: View {
    var isEnabled: Bool = true
    var text: String
    var body: some View {
        Text(text)
            .font(.callout)
            .fontWeight(.medium)
            .underline()
            .foregroundColor(Color("brandColor"))
            .opacity(isEnabled ? 1.0 : 0.5)
    }
}

#Preview {
    HyperLinkTextView(text: "Car")
}

