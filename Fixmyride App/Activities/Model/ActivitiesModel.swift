import SwiftUI

struct ActivitiesModel : Identifiable {
    var id: UUID = UUID()
    var bookingID: String
    var centerName: String
    var serviceDescription: String
    var price: String
    var date: String
    var time: String
    var status: Status
}

enum Status {
    case pending, upcoming, completed
}
