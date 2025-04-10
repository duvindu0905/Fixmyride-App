import SwiftUI

struct CommonSearchBarView: View {
    @Binding var isFocused: Bool
    @Binding var searchTerm: String
    var hint: String
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color.gray)
            TextField(hint, text: $searchTerm)
            if !searchTerm.isEmpty {
                Button {
                    searchTerm = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color.gray)
                }
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity)
        .background(Color("inputBackground"))
        .cornerRadius(15)
        .onTapGesture {
            isFocused = true
        }
    }
}

#Preview {
    //    PreviewSearchBar()
}

