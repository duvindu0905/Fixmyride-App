import SwiftUI

struct CommonNavigationListType3: View {
    var titleText: String
    var subtitleText: String
    var taglineText: String
    var body: some View {
        VStack(spacing: 4) {
            HStack {
                NormalTextView(text: titleText, foregroundColor: .black)
                Spacer()
            }
            HStack {
                NormalTextView(text: subtitleText)
                Spacer()
            }
            HStack {
                NormalTextView(
                    text: taglineText
                )
                Spacer()
            }
        }
    }
}

#Preview {
    CommonNavigationListType3(
        titleText: "car", subtitleText: "Car", taglineText: "car")
}
