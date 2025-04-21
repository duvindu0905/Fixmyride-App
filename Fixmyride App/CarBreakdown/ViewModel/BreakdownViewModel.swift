import SwiftUI
import MapKit
import CoreLocation

class BreakdownViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = BreakdownViewModel()

    @Published var selectedType: BreakdownType?
    @Published var userLocation: CLLocationCoordinate2D?
    @Published var selectedMechanic: Mechanic?
    @Published var availableMechanics: [Mechanic] = []
    @Published var selectedDate = Date()

    private let locationManager = CLLocationManager()

    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        userLocation = locations.first?.coordinate
    }

   
    func fetchNearbyMechanics() {
        guard let url = URL(string: "https://4wxr949qfc.execute-api.ap-southeast-1.amazonaws.com/live/api/breakdown/mechanics") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("❌ Failed to fetch mechanics:", error?.localizedDescription ?? "")
                return
            }

            do {
                struct APIResponse: Decodable {
                    let success: Bool
                    let data: [Mechanic]
                }

                let decoded = try JSONDecoder().decode(APIResponse.self, from: data)
                DispatchQueue.main.async {
                    self.availableMechanics = decoded.data
                }
            } catch {
                print("❌ JSON decode error:", error.localizedDescription)
            }
        }.resume()
    }

    func postBooking(mechanic: Mechanic, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "https://4wxr949qfc.execute-api.ap-southeast-1.amazonaws.com/live/api/breakdown/bookings") else { return }

        let bookingId = UUID().uuidString
        let email = GlobalDto.shared.email

        let body: [String: Any] = [
            "bookingId": bookingId,
            "customerEmail": email,
            "centerName": mechanic.name,
            "serviceType": selectedType?.title ?? "",
            "description": selectedType?.title ?? "",
            "date": ISO8601DateFormatter().string(from: selectedDate),
            "price": mechanic.price
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("❌ Booking failed:", error.localizedDescription)
                DispatchQueue.main.async { completion(false) }
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                print("📡 Status code:", httpResponse.statusCode)
            }

            if let data = data, let bodyString = String(data: data, encoding: .utf8) {
                print("📦 Response body:", bodyString)
            }

            DispatchQueue.main.async {
                completion(true)
            }
        }.resume()
    }

}

