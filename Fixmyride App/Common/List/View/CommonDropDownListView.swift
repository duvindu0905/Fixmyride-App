import SwiftUI

struct CommonDropDownListView: View {
    @Binding var options: [String]
    var titleText: String
    @Binding var selection: String

    var body: some View {
        HStack {
            NormalTextView(
                text: titleText, foregroundColor: .black)
            Spacer()
            Picker("", selection: $selection) {
                ForEach(options, id: \.self) { option in
                    NormalTextView(
                        text: option, foregroundColor: .black)
                }
            }
            .labelsHidden()
        }
    }
}

#Preview {
    //    CommonDropDownListView()
}

