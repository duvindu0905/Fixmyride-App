import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var globalDto: GlobalDto
    @State private var user: UserProfileModel = ProfileViewModel.shared.getUserProfile()

    var body: some View {
        ZStack {
            CommonBackgroundView()
            ScrollView {
                VStack(spacing: 16) {
                    HStack {
                        TitleTextView(text: user.firstName)
                        Spacer()
                        HyperLinkTextView(text: "Edit")
                            .onTapGesture {
                                globalDto.paths.append(Route.profileEdit.rawValue)
                            }
                    }
                    .padding(.horizontal, UIScreen.main.bounds.width * 0.05)

                    if #available(iOS 17.0, *) {
                        List {
                            
                            Section {
                                CommonStaticListView(
                                    icon: "", titleText: "First Name"
                                )
                                CommonStaticListView(
                                    icon: "", titleText: "Last Name"
                                )
                                CommonStaticListView(
                                    icon: "", titleText: "Email"
                                )
                                CommonStaticListView(
                                    icon: "", titleText: "Phone Number"
                                )
                                CommonStaticListView(
                                    icon: "", titleText: "Member Since"
                                )
                            }
                        }
                        .frame(height: UIScreen.main.bounds.height * 0.5)
                    }

                    VStack(spacing: 16) {
                        Button {
                            globalDto.paths.removeAll()
                            globalDto.isLoggedIn = false
                            globalDto.paths
                                .append(
                                    Route.login.rawValue
                                )
                        } label: {
                            CommonButtonView(
                                buttonText: "Sign Out",
                                backgroundColor: Color("inputBackground"),
                                foregroundColor: Color("brandColor")
                            )
                        }
                    }
                    .padding(.horizontal, UIScreen.main.bounds.width * 0.05)
                    Spacer()

                }
                .padding(.top, 32)
            }
        }
    }
}

// Preview
#Preview {
    ProfileView()
        .environmentObject(GlobalDto.shared)
}

