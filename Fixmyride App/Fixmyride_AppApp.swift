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
                        } else if destination == Route.forgotPasswordVerifyEmail.rawValue {
                            ForgotPasswordVerifyEmailView()
                        } else if destination == Route.forgotPasswordResetPassword.rawValue {
                            ResetPasswordView()
                        } else if destination == Route.home.rawValue {
                            TabLandingView() // ✅ Main tab-based screen with Home, Activities, Profile, etc.
                        } else if destination == Route.profile.rawValue {
                            ProfileView()
                        } else if destination == Route.profileEdit.rawValue {
                            ProfileEditView()
                        } else if destination == Route.notification.rawValue {
                            NotificationView()
                        } else if destination == Route.activities.rawValue {
                            ActivitiesView()
                        }
                        // Add more destinations here if needed
                    }
            }
            .accentColor(Color("brandColor"))
            .environmentObject(globalDto)
        }
    }
}

