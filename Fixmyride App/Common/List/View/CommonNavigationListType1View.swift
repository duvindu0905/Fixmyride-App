import SwiftUI

struct CommonNavigationListType1View: View {
    var icon: String
    var titleText: String
    var body: some View {
        HStack {
            Image(systemName: icon)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(Color("brandColor"))
                .frame(
                    width: UIScreen.main.bounds.width * 0.05,
                    height: UIScreen.main.bounds.width * 0.05
                )
                .padding(.trailing, 8)
            NormalTextView(text: titleText, foregroundColor: .black)
            Spacer()
        }
    }
}

#Preview {
    CommonNavigationListType1View(icon: "xmark", titleText: "car")
}

