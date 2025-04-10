import SwiftUI

class ActivitiesViewModel {
    static let shared = ActivitiesViewModel()
    private init() {}
    
    func getAllActivities() -> [ActivitiesModel] {
        let activities = [
            
            // Upcoming Activities
            ActivitiesModel(
                bookingID: "13213",
                centerName: "Kalindu Auto Repair Center",
                serviceDescription: "Car wash done.",
                price: "Rs. 1500.00",
                date: "13 Feb 2025",
                time: "11:30 AM",
                status: .upcoming
            ),
            ActivitiesModel(
                bookingID: "13101",
                centerName: "Kalindu Auto Repair Center",
                serviceDescription: "Car wash done.",
                price: "Rs. 1500.00",
                date: "07 Feb 2025",
                time: "11:30 AM",
                status: .upcoming
            ),
            
            // Completed Activities
            ActivitiesModel(
                bookingID: "13099",
                centerName: "Kalindu Auto Repair Center",
                serviceDescription: "Car wash done.",
                price: "Rs. 1500.00",
                date: "01 Feb 2025",
                time: "11:30 AM",
                status: .completed
            ),
            ActivitiesModel(
                bookingID: "13045",
                centerName: "Kalindu Auto Repair Center",
                serviceDescription: "Car wash done.",
                price: "Rs. 1500.00",
                date: "20 Jan 2025",
                time: "11:30 AM",
                status: .completed
            )
        ]
        
        return activities
    }
}
