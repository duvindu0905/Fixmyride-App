import SwiftUI

struct CommonNavigationListType4View: View {
    var titleText: String
    var subtitleText: String
    var descriptionText: String
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                NormalTextView(
                    text: titleText, foregroundColor: .black)
                Spacer()
                NormalTextView(text: subtitleText)
            }
            HStack {
                NormalTextView(
                    text:
                        descriptionText,
                    multilineTextAlignment: .leading
                )
                Spacer()
            }

        }
    }
}

#Preview {
    CommonNavigationListType4View(
        titleText: "car",
        subtitleText: "car",
        descriptionText: "car"
    )
}
