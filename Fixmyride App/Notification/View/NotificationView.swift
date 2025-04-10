import SwiftUI

struct NotificationView: View {
    @State var notificatins: [NotificationModel]?
    var body: some View {
        ZStack {
            CommonBackgroundView()
            VStack {
                HStack {
                    TitleTextView(text: "Notifications")
                    Spacer()
                }
                .padding(.horizontal, UIScreen.main.bounds.width * 0.05)

                if let notificatins = notificatins {
                    if #available(iOS 17.0, *) {
                        List {
                            ForEach(notificatins) { notification in
                                CommonNavigationListType4View(
                                    titleText: notification.title,
                                    subtitleText: notification.day,
                                    descriptionText: notification.message
                                )
                            }
                        }
                        .contentMargins(.vertical, 0)
                    } else {
                       
                    }
                } else {
                    FootnoteTextView(text: "No data")
                }

                Spacer()
            }
            .padding(.top, 32)
        }
        .onAppear {
            notificatins = NotificationViewModel.shared.getNotification()
        }
    }
}

#Preview {
    NotificationView()
}

