import SwiftUI

struct EmailOtpVerificationView: View {
    @EnvironmentObject var globalDto: GlobalDto
    @State var otp: [String] = Array(repeating: "", count: 4)
    @FocusState var focusedIndex: Int?
    @State var timer: Timer? = nil
    @State var timerValue: Int = 0
    @State var errorMessage: String?

    @State private var showFaceIDPrompt = false

    var body: some View {
        ZStack {
            CommonBackgroundView()
            VStack(spacing: 16) {
                Image("otpVerification")

                HeadingTextView(text: "Email OTP Verification")
                    .padding(.top, 16)

                NormalTextView(
                    text: "We've sent a 4-digit code to your email: \(globalDto.email)",
                    multilineTextAlignment: .center
                )

                otpInputField

                if let error = errorMessage {
                    FootnoteTextView(text: error)
                        .foregroundColor(.red)
                }

                verifyButton

                timerSection
            }
            .padding(.horizontal, UIScreen.main.bounds.width * 0.05)
        }
        .onAppear { startTimer() }
        .alert("Enable Face ID Login?", isPresented: $showFaceIDPrompt) {
            Button("Enable") {
                BiometricSettings.shared.setFaceIDEnabled(true)
                globalDto.paths = [Route.home.rawValue]
            }
            Button("Not Now", role: .cancel) {
                BiometricSettings.shared.setFaceIDEnabled(false)
                globalDto.paths = [Route.home.rawValue]
            }
        } message: {
            Text("Use Face ID for faster login next time.")
        }
    }

    var otpInputField: some View {
        HStack {
            ForEach(0..<4, id: \.self) { index in
                if #available(iOS 17.0, *) {
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
    }

    var verifyButton: some View {
        Button {
            let enteredOtp = otp.joined()
            Task {
                await verifyOtp(otp: enteredOtp)
            }
        } label: {
            CommonButtonView(
                buttonText: "Verify",
                backgroundColor: Color("brandColor"),
                foregroundColor: .white
            )
        }
    }

    func verifyOtp(otp: String) async {
        guard let url = URL(string: "https://4wxr949qfc.execute-api.ap-southeast-1.amazonaws.com/live/api/verify-otp?email=\(globalDto.email)") else {
            errorMessage = "Invalid URL"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["otp": otp]
        request.httpBody = try? JSONEncoder().encode(body)

        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            if let res = response as? HTTPURLResponse, res.statusCode == 200 {
                DispatchQueue.main.async {
                    showFaceIDPrompt = true
                }
            } else {
                DispatchQueue.main.async {
                    errorMessage = "Invalid OTP. Please try again."
                }
            }
        } catch {
            DispatchQueue.main.async {
                errorMessage = "Server error. Try again later."
            }
        }
    }

    var timerSection: some View {
        HStack {
            NormalTextView(text: "Request code again in")
            if timerValue > 0 {
                HighlightedTextView(text: "\(timerValue) s")
            } else {
                HyperLinkTextView(text: "retry")
                    .onTapGesture {
                        startTimer()
                    }
            }
        }
    }

    func startTimer() {
        timerValue = 120
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

