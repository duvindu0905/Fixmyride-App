import SwiftUI

struct EmailOtpVerificationView: View {
    @EnvironmentObject var globalDto: GlobalDto
    @State var otp: [String] = Array(repeating: "", count: 4)
    @FocusState var focusedIndex: Int?
    @State var timer: Timer? = nil
    @State var timerValue: Int = 0

    var body: some View {
        ZStack {
            CommonBackgroundView()
            VStack(spacing: 16) {
                Image("otpVerification")
                HeadingTextView(text: "Email OTP Verification")
                    .padding(.top, 16)
                NormalTextView(
                    text: "We've sent a 4-digit code to your university email",
                    multilineTextAlignment: .center
                )

                otpInputField

                verifyButton

                timerSection
            }
            .padding(.horizontal, UIScreen.main.bounds.width * 0.05)
        }
        .onAppear { startTimer() }
    }

    var otpInputField: some View {
        HStack {
            ForEach(0..<4, id: \.self) { index in
                OtpTextInputView(input: $otp[index])
                    .focused($focusedIndex, equals: index)
                    .onChange(of: otp[index]) {
                        if otp[index].count > 1 {
                            otp[index] = String(otp[index].prefix(1))
                        }
                        if !otp[index].isEmpty {
                            focusedIndex = (index < 3) ? index + 1 : nil
                        }
                    }
            }
        }
    }

    var verifyButton: some View {
        Button {
            let enteredOtp = otp.joined()
            print("Email OTP entered: \(enteredOtp)")
            // Navigation logic
            if globalDto.commingFrom == Route.forgotPasswordVerifyEmail.rawValue {
                globalDto.paths.append(Route.forgotPasswordResetPassword.rawValue)
            } else if globalDto.commingFrom == Route.registration.rawValue {
                globalDto.isLoggedIn = true
                globalDto.role = .scholar
                globalDto.paths.append(Route.home.rawValue)
            }
        } label: {
            CommonButtonView(
                buttonText: "Verify",
                backgroundColor: Color("brandColor"),
                foregroundColor: .white
            )
        }
    }

    var timerSection: some View {
        HStack {
            NormalTextView(text: "Request code again in")
            if timerValue > 0 {
                HighlightedTextView(text: "\(timerValue) s")
            } else {
                HyperLinkTextView(text: "retry")
                    .onTapGesture { startTimer() }
            }
        }
    }

    func startTimer() {
        timerValue = timerValue != 0 ? timerValue : 120
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timerValue > 0 {
                timerValue -= 1
            } else {
                stopTimer()
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
    }
}

#Preview {
    EmailOtpVerificationView().environmentObject(GlobalDto.shared)
}

