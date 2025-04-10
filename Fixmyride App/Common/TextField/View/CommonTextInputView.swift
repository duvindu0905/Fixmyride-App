import SwiftUI

struct CommonTextInputView: View {
    var hint: String
    @Binding var text: String
    var body: some View {
        TextField(hint, text: $text)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color("inputBackground"))
            .cornerRadius(15)
    }
}

#Preview {
    PreviewTextInput()
}

struct PreviewTextInput: View {
    @State var temp: String = ""
    var body: some View {
        CommonTextInputView(hint: "Email", text: $temp)
    }
}

