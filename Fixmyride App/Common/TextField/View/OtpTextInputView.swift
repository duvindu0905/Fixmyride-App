import SwiftUI

struct OtpTextInputView: View {
    @Binding var input: String
    var body: some View {
        TextField("", text: $input)
            .padding()
            .frame(
                width: UIScreen.main.bounds.width * 0.15,
                height: UIScreen.main.bounds.width * 0.15
            )
            .background(Color("inputBackground"))
            .cornerRadius(15)
            .multilineTextAlignment(.center)
            .keyboardType(.numberPad)
    }
}

#Preview {
    PreviewTextInputOtp()
}

struct PreviewTextInputOtp: View {
    @State var temp: String = ""
    var body: some View {
        OtpTextInputView(input: $temp)
    }
}

