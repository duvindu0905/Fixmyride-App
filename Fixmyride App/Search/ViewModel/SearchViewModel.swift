import MapKit
import SwiftUI

class MapViewModel {
    static let shared = MapViewModel()
    private init() {}
    
    func getLatestSearches() -> [GarageModel] {
        return getRelevantMap().garages
    }
    
    func getRelevantMap() -> MapModel {
        let garages: [GarageModel] = [
            .init(
                garageId: 1,
                name: "Oakland Auto Repair",
                type: .repairCenter,
                mobile: "+1 (510) 555-1234",
                latitude: 37.8044,
                longitude: -122.2711,
                address: "2400 Broadway, Oakland, CA",
                imageUrls: ["https://www.oaklandmagazine.com/wp-content/uploads/2021/05/2013_05_omam_best_of_torchios_auto_repair_010-1000x640.jpg"],
                availabilityInDouble: 75.0,
                availabilityInString: .moderate
            ),
            .init(
                garageId: 2,
                name: "Downtown Auto Experts",
                type: .engineering,
                mobile: "+1 (415) 555-5678",
                latitude: 37.7749,
                longitude: -122.4194,
                address: "500 Market St, San Francisco, CA",
                imageUrls: ["https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQf5VTjfmno51vK8AP66ZGFoiiIS4YPtQs5_Q&s"],
                availabilityInDouble: 65.0,
                availabilityInString: .moderate
            ),
            .init(
                garageId: 3,
                name: "Santa Clara Car Care",
                type: .detailing,
                mobile: "+1 (408) 555-9999",
                latitude: 37.3541,
                longitude: -121.9552,
                address: "123 El Camino Real, Santa Clara, CA",
                imageUrls: ["https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQZy93hhtKiglPfv40nRrDNlqjGQUNhhAyZ1g&s"],
                availabilityInDouble: 90.0,
                availabilityInString: .high
            ),
            .init(
                garageId: 4,
                name: "Berkeley Precision Motors",
                type: .repairCenter,
                mobile: "+1 (510) 555-8765",
                latitude: 37.8715,
                longitude: -122.2730,
                address: "700 University Ave, Berkeley, CA",
                imageUrls: ["https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSgS_FVCX8lpHMXWSpb7QLRMTW2vzUWyq86MkStT3cUroFZhQp_Ds_FH_wIkUlY2KzBn3M&usqp=CAU"],
                availabilityInDouble: 40.0,
                availabilityInString: .low
            )
        ]
        
        return MapModel(mapId: 2, name: "Bay Area Garage Map", garages: garages)
    }
}
