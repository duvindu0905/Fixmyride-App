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

                List(viewModel.emergencyContacts, id: \.id) { contact in
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
                    .contentShape(Rectangle()) // make whole row tappable
                    .onTapGesture {
                        
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
                if let phoneURL = URL(string: "tel://\(selectedNumber)") {
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

