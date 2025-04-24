import SwiftUI

struct EmergencyContactsView: View {
    @ObservedObject var viewModel = EmergencyContactViewModel.shared

    @State private var showCallAlert = false
    @State private var selectedNumber = ""
    @State private var selectedTitle = ""

    var body: some View {
        ZStack {
            CommonBackgroundView()

            VStack {
                HStack {
                    TitleTextView(text: "Emergency")
                    Spacer()
                }
                .padding(.top, 32)
                .padding(.horizontal, UIScreen.main.bounds.width * 0.05)

                List(viewModel.emergencyContacts) { contact in
                    HStack {
                        CommonNavigationListType2View(
                            icon: contact.iconName,
                            titleText: contact.title,
                            tagText: contact.phoneNumber,
                            tagText2: ""
                        )

                        Spacer()

                        Image(systemName: "phone.fill")
                            .foregroundColor(.green)
                            .padding(.trailing, 8)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedNumber = contact.phoneNumber
                        selectedTitle = contact.title
                        showCallAlert = true
                    }
                }
            }
        }
        .onAppear {
            viewModel.fetchFromCoreData()
            viewModel.fetchFromAPI()
        }
        .alert("Call \(selectedTitle)?", isPresented: $showCallAlert) {
            Button("Call", role: .destructive) {
                let sanitized = selectedNumber
                    .components(separatedBy: CharacterSet.decimalDigits.inverted)
                    .joined()
                if let phoneURL = URL(string: "tel://\(sanitized)"),
                   UIApplication.shared.canOpenURL(phoneURL) {
                    UIApplication.shared.open(phoneURL)
                }
            }
            Button("Cancel", role: .cancel) { }
        }
    }
}

#Preview {
    EmergencyContactsView()
}

