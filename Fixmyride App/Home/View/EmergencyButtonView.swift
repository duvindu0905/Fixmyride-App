import SwiftUI

struct EmergencyButtonView: View {
    var icon: String = "phone.fill"
    var iconColor: Color = .red

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
                RoundedRectangle(cornerRadius: 12)
                    .stroke(iconColor, lineWidth: 1)
            )
    }
}

#Preview {
    EmergencyButtonView()
}

