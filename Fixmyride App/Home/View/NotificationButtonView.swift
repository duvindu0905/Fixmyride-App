import SwiftUI

struct NotificationButtonView: View {
    var icon: String = "bell.fill"
    var iconColor: Color = Color("commonTextColor")
    var body: some View {
        Image(systemName: icon)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundColor(iconColor)
            .frame(
                width: UIScreen.main.bounds.width * 0.07,
                height: UIScreen.main.bounds.width * 0.07
            )
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color("commonTextColor"), lineWidth: 1)
            )
    }
}

#Preview {
    NotificationButtonView()
}

