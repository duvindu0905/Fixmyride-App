import SwiftUI

struct ProfileEditView: View {
    @EnvironmentObject var globalDto: GlobalDto
    @ObservedObject var viewModel = ProfileViewModel.shared

    @State var firstName: String = ""
    @State var lastName: String = ""
    @State var phoneNumber: String = ""

    var body: some View {
        ZStack {
            CommonBackgroundView()

            if let user = viewModel.userProfile {
                VStack {
                    HStack {
                        TitleTextView(text: user.firstName)
                        Spacer()
                        if firstName != user.firstName
                            || lastName != user.lastName
                            || phoneNumber != String(user.phoneNumber) {
                            HyperLinkTextView(text: "Done")
                                .onTapGesture {
                                    let updatedUser = UserProfileModel(
                                        id: user.id,
                                        firstName: firstName,
                                        lastName: lastName,
                                        email: user.email,
                                        phoneNumber: Int(phoneNumber) ?? 0,
                                        memberSince: user.memberSince
                                    )

                                    viewModel.updateUserProfile(updatedUser) { success in
                                        if success {
                                            DispatchQueue.main.async {
                                                globalDto.paths.removeLast()
                                            }
                                        }
                                    }
                                }
                        } else {
                            HyperLinkTextView(isEnabled: false, text: "Done")
                        }
                    }
                    .padding(.horizontal)

                    if #available(iOS 17.0, *) {
                        List {
                            Section {
                                CommonListTextInputView(
                                    firstName: $firstName,
                                    titleText: "First Name",
                                    placeholderText: "Enter your first name"
                                )

                                CommonListTextInputView(
                                    firstName: $lastName,
                                    titleText: "Last Name",
                                    placeholderText: "Enter your last name"
                                )

                                CommonListTextInputView(
                                    firstName: $phoneNumber,
                                    titleText: "Phone Number",
                                    placeholderText: "Enter your phone number"
                                )
                            }
                        }
                        .contentMargins(.vertical, 40)
                        
                    }
                }
                .padding(.top, 32)
                .onAppear {
                    firstName = user.firstName
                    lastName = user.lastName
                    phoneNumber = String(user.phoneNumber)
                }
            }
        }
        .onAppear {
            viewModel.fetchUserProfile(byEmail: globalDto.email)
        }
    }
}

#Preview {
    ProfileEditView()
        .environmentObject(GlobalDto.shared)
}

