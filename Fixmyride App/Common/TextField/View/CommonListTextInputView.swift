import SwiftUI

struct CommonListTextInputView: View {
    @Binding var firstName: String
    var titleText: String
    var placeholderText: String

    var body: some View {
        HStack {
            NormalTextView(
                text: titleText, foregroundColor: .black)
            Spacer()
            TextField(placeholderText, text: $firstName)
                .font(.callout)
                .fontWeight(.medium)
                .foregroundColor(.black)
                .multilineTextAlignment(.trailing)
        }
    }
}

#Preview {
    //    CommonListTextInputView()
}

