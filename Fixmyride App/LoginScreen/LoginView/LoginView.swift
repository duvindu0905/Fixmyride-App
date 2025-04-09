import SwiftUI

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()

    var body: some View {
        ZStack {
            CommonBackgroundView()
            VStack(spacing: 16) {
                Image("logo")
                HeadingTextView(text: "Sign In")
                    .padding(.top, 16)
                NormalTextView(
                    text: "Access to your account",
                    multilineTextAlignment: .center
                )

                CommonTextInputView(
                    hint: "Mobile Number or Email Address",
                    text: $viewModel.emailOrPhone
                )

                if let errorMessage = viewModel.errorMessage {
                    FootnoteTextView(text: errorMessage)
                        .foregroundColor(.red)
                }

                Button(action: {
                    viewModel.login()
                }) {
                    CommonButtonView(
                        buttonText: "Sign In",
                        backgroundColor: .brandcolor,
                        foregroundColor: .white
                    )
                }
                .padding(.horizontal)

                Button(action: {
                    // Google sign-in logic
                }) {
                    CommonButtonView(
                    
                        buttonText: "Continue with Google",
                        backgroundColor: .white,
                        foregroundColor: .black
                    )
                }
                .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.gray, lineWidth: 1))
                .padding(.horizontal)

                Spacer()

                HStack {
                    NormalTextView(text: "Not a service provider?")
                    Button("Register now") {
                        // Navigation to registration
                    }
                    .foregroundColor(.brandcolor)
                }
            }
            .padding()
        }
    }
}

#Preview {
    LoginView()
}

