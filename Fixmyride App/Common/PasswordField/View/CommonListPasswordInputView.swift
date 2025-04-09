import SwiftUI

struct CommonListPasswordInputView: View {
    @Binding var password: String
    var titleText: String
    var body: some View {
        HStack {
            NormalTextView(
                text: titleText,
                foregroundColor: .black)
            Spacer()
            SecureField("************", text: $password)
                .font(.callout)
                .fontWeight(.medium)
                .foregroundColor(.black)
                .multilineTextAlignment(.trailing)
        }
    }
}

#Preview {
    //    CommonListPasswordInputView()
}

