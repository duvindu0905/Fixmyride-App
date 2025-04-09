import SwiftUI

struct ForgotPasswordVerifyEmailView: View {
    @EnvironmentObject var globalDto: GlobalDto
    @State var universityEmail: String = ""

    var body: some View {
        ZStack {
            CommonBackgroundView()
            VStack(spacing: 16) {
                Image("forgotPasswordEmailVerify")
                HeadingTextView(text: "Forgot Password")
                    .padding(.top, 16)
                NormalTextView(
                    text: "Don't worry! Please enter your university email.",
                    multilineTextAlignment: .center
                )

                CommonTextInputView(
                    hint: "University Email",
                    text: $universityEmail
                )

                Button {
                    globalDto.commingFrom =
                        Route.forgotPasswordVerifyEmail.rawValue
                    globalDto.paths.append(
                        Route.otpVerification.rawValue)
                } label: {
                    CommonButtonView(
                        buttonText: "Verify Email",
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
    ForgotPasswordVerifyEmailView().environmentObject(GlobalDto.shared)
}

