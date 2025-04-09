import SwiftUI

struct CommonButtonView: View {
    var buttonText: String
    var backgroundColor: Color
    var foregroundColor: Color
    var body: some View {
        Text(buttonText)
            .font(.callout)
            .fontWeight(.bold)
            .foregroundColor(foregroundColor)
            .padding(.vertical)
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .cornerRadius(15)

    }
}

#Preview {
    CommonButtonView(
        buttonText: "Sign In",
        backgroundColor: Color.blue,
        foregroundColor: Color.white
    )
}

