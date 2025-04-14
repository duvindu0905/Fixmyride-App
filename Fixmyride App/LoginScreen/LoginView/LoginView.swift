import SwiftUI

struct LoginView: View {
    @EnvironmentObject var globalDto: GlobalDto
    @StateObject private var viewModel = LoginViewModel()

    var body: some View {
        ZStack {
            CommonBackgroundView()
            VStack(spacing: 16) {
                Image("logo")

                HeadingTextView(text: "Sign In")
                    .padding(.top, 16)

                NormalTextView(
                    text: "Access your account with your email",
                    multilineTextAlignment: .center
                )

                CommonTextInputView(
                    hint: "Email Address",
                    text: $viewModel.email
                )
                HStack {
                    Spacer()
                    HyperLinkTextView(text: "Forgot password?")
                        .onTapGesture {
                            globalDto.paths
                                .append(
                                    Route.forgotPasswordVerifyEmail.rawValue
                                )
                        }
                }

                if let errorMessage = viewModel.errorMessage {
                    FootnoteTextView(text: errorMessage)
                        .foregroundColor(.red)
                }

                Button(action: {
                    if viewModel.login() {
                        globalDto.email = viewModel.email
                        globalDto.comingFrom = Route.login.rawValue
                        globalDto.paths.append(Route.otpVerification.rawValue)
                    }
                }) {
                    CommonButtonView(
                        buttonText: "Sign In",
                        backgroundColor: Color("brandColor"),
                        foregroundColor: .white
                    )
                }

                Spacer()

                HStack {
                    NormalTextView(text: "Don't have an account?")
                    Button("Register now") {
                        globalDto.comingFrom = Route.login.rawValue
                        
                    }
                    .foregroundColor(.brand)
                }
            }
            .padding()
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(GlobalDto.shared)
}
