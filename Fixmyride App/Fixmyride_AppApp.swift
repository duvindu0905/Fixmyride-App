import SwiftUI

@main
struct FixMyRideApp: App {
    @StateObject var globalDto = GlobalDto.shared

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $globalDto.paths) {
                LoginView() // Root view on launch

                    .navigationDestination(for: String.self) { destination in
                        if destination == Route.login.rawValue {
                            LoginView()
                        } else if destination == Route.otpVerification.rawValue {
                            EmailOtpVerificationView()
                        } else if destination == Route.home.rawValue {
                            TabLandingView()
                        } else if destination == Route.profile.rawValue {
                            ProfileView()
                        } else if destination == Route.profileEdit.rawValue {
                            ProfileEditView()
                        } else if destination == Route.notification.rawValue {
                            NotificationView()
                        } else if destination == Route.activities.rawValue {
                            ActivitiesView()
                        } else if destination == Route.emergency.rawValue {
                            EmergencyContactsView()
                        }
                    }
            }
            .accentColor(Color("brandColor"))
            .environmentObject(globalDto)
        }
    }
}

