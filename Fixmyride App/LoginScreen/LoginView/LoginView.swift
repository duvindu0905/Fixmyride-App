import SwiftUI

struct LoginView: View {
    @EnvironmentObject var globalDto: GlobalDto
    @State var Email: String = ""
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
                        backgroundColor: .brand,
                        foregroundColor: .white
                    )
                }
                

                Button(action: {
                   
                }) {
                    CommonButtonView(
                    
                        buttonText: "Continue with Google",
                        backgroundColor: .white,
                        foregroundColor: .black
                    )
                }
                .overlay(RoundedRectangle(cornerRadius: 15).stroke(Color.gray, lineWidth: 1))
                

                Spacer()

                HStack {
                    NormalTextView(text: "Not a service provider?")
                    Button("Register now") {
                        // Navigation to registration
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
}

