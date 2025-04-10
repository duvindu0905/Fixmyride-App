import SwiftUI

struct ProfileEditView: View {
    @EnvironmentObject var globalDto: GlobalDto
    @State var user: UserProfileModel?
    @State var firstName: String = ""
    @State var lastName: String = ""

    var body: some View {
        ZStack {
            CommonBackgroundView()
            if let user = user {
                VStack {
                    HStack {
                        TitleTextView(text: user.firstName)
                        Spacer()
                        if firstName != user.firstName
                            || lastName != user.lastName
                        {
                            HyperLinkTextView(text: "Done")
                                .onTapGesture {
                                    globalDto.paths
                                        .removeLast()
                                }
                        } else {
                            HyperLinkTextView(isEnabled: false, text: "Done")
                        }

                    }
                    .padding(.horizontal, UIScreen.main.bounds.width * 0.05)

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
                                
                            }
                        }
                        .contentMargins(.vertical, 0)
                    } else {
                        // Fallback on earlier versions
                    }
                }
                .padding(.top, 32)
            }
        }
        .onAppear {
            user = ProfileViewModel.shared
                .getUserProfile()
            if let user = user {
                firstName = user.firstName
                lastName = user.lastName
            }
        }
    }
}

#Preview {
    ProfileEditView()
}

