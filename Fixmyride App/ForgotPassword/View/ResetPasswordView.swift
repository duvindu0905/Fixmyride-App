import SwiftUI

struct ResetPasswordView: View {
    @EnvironmentObject var globalDto: GlobalDto
    @State var newPassword: String = ""
    @State var confirmPassword: String = ""
    var body: some View {
        ZStack {
            CommonBackgroundView()
            VStack(spacing: 16) {
                Image("forgotPasswordResetPassword")
                HeadingTextView(text: "Reset Password")
                    .padding(.top, 16)
                CommonPasswordInputView(
                    hint: "New Password", password: $newPassword)
                CommonPasswordInputView(
                    hint: "Confirm Password", password: $confirmPassword)
                NormalTextView(
                    text:
                        "Your password must be at least 8 characters, include a number, an uppercase letter, a lowercase letter and a special character.",
                    multilineTextAlignment: .center
                )

                Button {
                    globalDto.paths
                        .append(Route.login.rawValue)
                } label: {
                    CommonButtonView(
                        buttonText: "Reset",
                        backgroundColor: Color("brandColor"),
                        foregroundColor: Color.white
                    )
                }
            }
            .padding(.horizontal, UIScreen.main.bounds.width * 0.05)
        }
    }
}

#Preview {
    ResetPasswordView()
}

