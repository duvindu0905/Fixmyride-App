import SwiftUI

struct NotificationView: View {
    @StateObject private var viewModel = NotificationViewModel.shared

    var body: some View {
        ZStack {
            CommonBackgroundView()
            VStack {
                HStack {
                    TitleTextView(text: "Notifications")
                    Spacer()
                }
                .padding(.horizontal, UIScreen.main.bounds.width * 0.05)

                if !viewModel.notifications.isEmpty {
                    if #available(iOS 17.0, *) {
                        List {
                            ForEach(viewModel.notifications) { notification in
                                CommonNavigationListType4View(
                                    titleText: notification.title,
                                    subtitleText: notification.day, 
                                    descriptionText: notification.message
                                )
                            }
                        }
                        .contentMargins(.vertical, 10)
                    } else {
                        Text("List for iOS <17.0 not implemented.")
                    }
                } else {
                    FootnoteTextView(text: "No data")
                }

                Spacer()
            }
            .padding(.top, 32)
        }
        .onAppear {
            viewModel.getNotification { fetched in
                viewModel.notifications = fetched
            }
        }
    }
}

#Preview {
    NotificationView()
}

