import SwiftUI
import UserNotifications

@main
struct FixMyRideApp: App {
    @StateObject var globalDto = GlobalDto.shared
    
    private let notificationDelegate = NotificationDelegate()

       init() {
           LocalNotificationManager.shared.requestPermission()
           UNUserNotificationCenter.current().delegate = notificationDelegate 
       }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $globalDto.paths) {
                LoginView()

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
                        }else if destination == Route.garage.rawValue {
                            MapView()
                        }else if destination == Route.arCarModification.rawValue {
                            ARCarModificationView()
                        }else if destination == Route.breakdown.rawValue {
                            BreakdownFlowView()
                        }else if destination == Route.carRepair.rawValue {
                            CarRepairFlowView()
                        }else if destination == Route.carWash.rawValue {
                            CarWashFlowView()
                        }

                    }
            }
            .accentColor(Color("brandColor"))
            .environmentObject(globalDto)
        }
    }
}

