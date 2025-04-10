import SwiftUI

struct NotificationModel: Identifiable {
    var id: UUID = UUID()
    var title: String
    var message: String
    var day: String
}
