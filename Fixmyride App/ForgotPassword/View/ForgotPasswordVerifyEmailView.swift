import SwiftUI

struct ForgotPasswordVerifyEmailView: View {
    @EnvironmentObject var globalDto: GlobalDto
    @State var email: String = ""

    var body: some View {
        ZStack {
            CommonBackgroundView()
            VStack(spacing: 16) {
                Image("forgotPasswordEmailVerify")

                HeadingTextView(text: "Forgot Password")
                    .padding(.top, 16)

                NormalTextView(
                    text: "Don't worry! Please enter your email.",
                    multilineTextAlignment: .center
                )

                CommonTextInputView(
                    hint: "Email",
                    text: $email
                )

                Button {
                    globalDto.comingFrom = Route.forgotPasswordVerifyEmail.rawValue
                    globalDto.email = email
                    globalDto.paths.append(Route.otpVerification.rawValue)
                } label: {
                    CommonButtonView(
                        buttonText: "Verify Email",
                        backgroundColor: Color("brandColor"),
                        foregroundColor: .white
                    )
                }
            }
            .padding(.horizontal, UIScreen.main.bounds.width * 0.05)
        }
    }
}

#Preview {
    ForgotPasswordVerifyEmailView().environmentObject(GlobalDto.shared)
}

