import SwiftUI

class NotificationViewModel {
    static let shared = NotificationViewModel()

    private init() {}

    func getNotification() -> [NotificationModel] {
        let notifications: [NotificationModel] = [
            .init(
                title: "Ceylon Motor works Services",
                message:
                    "Car wash completed.",
                day: "2025-04-02"),
            .init(
                title: "Ceylon Motor works Services",
                message:
                    "Car wash booked.",
                day: "2025-04-01"),
        ]
        return notifications
    }
}
