import SwiftUI
import CoreData

class EmergencyContactViewModel: ObservableObject {
    static let shared = EmergencyContactViewModel()

    @Published var emergencyContacts: [EmergencyContact] = []

    
    func fetchFromAPI() {
      

        let hardcoded: [EmergencyContact] = [
            EmergencyContact(title: "Police Emergency", phoneNumber: "119", iconName: iconFor(title: "Police Emergency")),
            EmergencyContact(title: "Fire Department", phoneNumber: "110", iconName: iconFor(title: "Fire Department")),
            EmergencyContact(title: "General Hospital", phoneNumber: "+94 11 732 1005", iconName: iconFor(title: "Hospital")),
            EmergencyContact(title: "Highway Help", phoneNumber: "1969", iconName: iconFor(title: "Highway Help")),
            EmergencyContact(title: "FixMyRide Office", phoneNumber: "+94 776632994", iconName: iconFor(title: "FixMyRide"))
        ]

        DispatchQueue.main.async {
            self.emergencyContacts = hardcoded
            self.saveToCoreData(hardcoded)
        }
    }


    private func saveToCoreData(_ contacts: [EmergencyContact]) {
        let context = CoreDataManager.shared.context

        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: EmergencyContactEntity.fetchRequest())
        _ = try? context.execute(deleteRequest)

        contacts.forEach { contact in
            let entity = EmergencyContactEntity(context: context)
            entity.title = contact.title
            entity.phoneNumber = contact.phoneNumber
        }

        CoreDataManager.shared.saveContext()
    }

    func fetchFromCoreData() {
        let context = CoreDataManager.shared.context
        let request = EmergencyContactEntity.fetchRequest()

        if let results = try? context.fetch(request) {
            self.emergencyContacts = results.map {
                EmergencyContact(
                    title: $0.title ?? "",
                    phoneNumber: $0.phoneNumber ?? "",
                    iconName: self.iconFor(title: $0.title ?? "")
                )
            }
        } else {
            print("⚠️ Failed to fetch emergency contacts from Core Data")
        }
    }

  
    private func iconFor(title: String) -> String {
        let lowercase = title.lowercased()

        if lowercase.contains("police") {
            return "shield.lefthalf.fill"
        } else if lowercase.contains("fire") {
            return "flame.fill"
        } else if lowercase.contains("hospital") || lowercase.contains("medical") {
            return "cross.case.fill"
        } else if lowercase.contains("fixmyride") {
            return "car.fill"
        } else if lowercase.contains("highway") {
            return "car.2.fill"
        } else {
            return "phone.fill"
        }
    }
}

