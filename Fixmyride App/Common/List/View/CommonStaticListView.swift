import SwiftUI

struct CommonStaticListView: View {
    var icon: String
    var titleText: String
    var valueColor: Color = Color("commonTextColor")
    var body: some View {
        HStack {
            if !icon.isEmpty {
                Image(systemName: icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(Color("brandColor"))
                    .frame(
                        width: UIScreen.main.bounds.width * 0.05,
                        height: UIScreen.main.bounds.width * 0.05
                    )
                    .padding(.trailing, 8)
            }
            NormalTextView(text: titleText, foregroundColor: .black)
            Spacer()
           
        }
    }
}

#Preview {
    CommonStaticListView(
        icon: "checkmark.circle.fill", titleText: "Availability")
}

