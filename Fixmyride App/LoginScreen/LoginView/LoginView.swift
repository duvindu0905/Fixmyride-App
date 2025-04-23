import SwiftUI
import LocalAuthentication

struct LoginView: View {
    @EnvironmentObject var globalDto: GlobalDto
    @StateObject private var viewModel = LoginViewModel()
    @State private var didTryFaceID = false

    var body: some View {
        ZStack {
            CommonBackgroundView()

            VStack(spacing: 16) {
                Spacer()
                Image("logo")

                HeadingTextView(text: "Sign In")
                    .padding(.top, 16)

                NormalTextView(
                    text: "Access your account with your email",
                    multilineTextAlignment: .center
                )

                CommonTextInputView(
                    hint: "Enter Your Email Address",
                    text: $viewModel.email
                )

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
                    NormalTextView(text: "Not a service provider?")
                    HyperLinkTextView(text: "Register now")
                        .onTapGesture {
                            globalDto.comingFrom = Route.login.rawValue
                           
                        }
                }
            }
            .padding(.horizontal, UIScreen.main.bounds.width * 0.05)
        }
        .onAppear {
            if !didTryFaceID {
                tryFaceIDLogin()
                didTryFaceID = true
            }
        }
    }

   
    func tryFaceIDLogin() {
        if BiometricSettings.shared.isFaceIDEnabled() {
            let context = LAContext()
            var error: NSError?

            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                let reason = "Authenticate with Face ID to access your account."

                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authError in
                    DispatchQueue.main.async {
                        if success {
                            globalDto.isLoggedIn = true
                            globalDto.paths = [Route.home.rawValue]
                        } else {
                            viewModel.errorMessage = authError?.localizedDescription ?? "Face ID failed"
                        }
                    }
                }
            } else {
                viewModel.errorMessage = "Face ID is not available on this device"
            }
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(GlobalDto.shared)
}

