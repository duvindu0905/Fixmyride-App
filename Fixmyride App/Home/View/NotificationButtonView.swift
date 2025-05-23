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
                width: UIScreen.main.bounds.width * 0.05,
                height: UIScreen.main.bounds.width * 0.05
            )
            .padding(8) 
            .background(
                RoundedRectangle(cornerRadius: 12)                     .stroke(iconColor, lineWidth: 1)
            )
    }
}

#Preview {
    NotificationButtonView()
}

