import MapKit
import SwiftUI

class MapViewModel: ObservableObject {
    static let shared = MapViewModel()
    private init() {}

    @Published var garages: [GarageModel] = []

    
    func fetchGarages() {
        guard let url = URL(string: "https://4wxr949qfc.execute-api.ap-southeast-1.amazonaws.com/live/api/search/garages") else { return }
        

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching garages:", error?.localizedDescription ?? "Unknown error")
                return
            }

            do {
                let fetchedGarages = try JSONDecoder().decode([GarageModel].self, from: data)
                DispatchQueue.main.async {
                    self.garages = fetchedGarages
                }
            } catch {
                print("Decoding error:", error.localizedDescription)
            }
        }.resume()
    }

    func getLatestSearches() -> [GarageModel] {
        return garages
    }

}
