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
                        Spacer()
                        VStack(spacing: 0) {
                            CommonStaticListView(icon: "", titleText: "First Name", valueText: user.firstName)
                            Spacer()
                            CommonStaticListView(icon: "", titleText: "Last Name", valueText: user.lastName)
                            Spacer()
                            CommonStaticListView(icon: "",
                                                 titleText: "Email", valueText: user.email)
                            Spacer()
                            CommonStaticListView(icon: "", titleText: "Phone Number", valueText: String(user.phoneNumber))
                            Spacer()
                            CommonStaticListView(icon: "", titleText: "Member Since", valueText: user.memberSince)
                        }
                        .background(Color.white)
                        .cornerRadius(12)
                        
                        Spacer()
                        Spacer()
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
                        
                        .padding(.horizontal, UIScreen.main.bounds.width * 0.05)
                        Spacer()

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
