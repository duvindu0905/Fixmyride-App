import SwiftUI

struct CommonPasswordInputView: View {
    var hint: String
    @Binding var password: String
    var body: some View {
        SecureField(hint, text: $password)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color("inputBackground"))
            .cornerRadius(15)
    }
}

#Preview {
    PreviewPasswordInput()
}

struct PreviewPasswordInput: View {
    @State var temp: String = ""
    var body: some View {
        CommonPasswordInputView(hint: "Password", password: $temp)
    }
}

