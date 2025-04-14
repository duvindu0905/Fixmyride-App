import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var globalDto: GlobalDto
    @ObservedObject var viewModel = ProfileViewModel.shared

    var body: some View {
        ZStack {
            CommonBackgroundView()

            if let user = viewModel.userProfile {
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
                        .padding(.horizontal)

                        VStack(spacing: 0) {
                            CommonStaticListView(icon: "", titleText: "First Name", descriptionText: user.firstName)
                            CommonStaticListView(icon: "", titleText: "Last Name", descriptionText: user.lastName)
                            CommonStaticListView(icon: "", titleText: "Email", descriptionText: user.email)
                            CommonStaticListView(icon: "", titleText: "Phone Number", descriptionText: String(user.phoneNumber))
                            CommonStaticListView(icon: "", titleText: "Member Since", descriptionText: user.memberSince)
                        }
                        .background(Color.white)
                        .cornerRadius(12)
                        .padding(.horizontal)

                        VStack(spacing: 16) {
                            Button {
                                globalDto.paths.removeAll()
                                globalDto.isLoggedIn = false
                                globalDto.paths.append(Route.login.rawValue)
                            } label: {
                                CommonButtonView(
                                    buttonText: "Sign Out",
                                    backgroundColor: Color("inputBackground"),
                                    foregroundColor: Color("brandColor")
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.top, 32)
                }
            }
        }
        .onAppear {
            viewModel.fetchUserProfile(byEmail: globalDto.email)
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(GlobalDto.shared)
}
