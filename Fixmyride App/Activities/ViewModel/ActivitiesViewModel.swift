import SwiftUI

class ActivitiesViewModel: ObservableObject {
    static let shared = ActivitiesViewModel()

    @Published var activities: [ActivityModel] = []

    private init() {}

    func getCompletedActivities(completion: @escaping ([ActivityModel]) -> Void) {
        guard let url = URL(string: "https://4wxr949qfc.execute-api.ap-southeast-1.amazonaws.com/live/api/activities/completed") else {
            print("Invalid URL")
            completion([])
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                completion([])
                return
            }

            do {
                var decoded = try JSONDecoder().decode([ActivityModel].self, from: data)

                let formatterIn = ISO8601DateFormatter()
                let formatterOut = DateFormatter()
                formatterOut.dateFormat = "dd MMM yyyy hh:mm a"

                decoded = decoded.map { activity in
                    var updated = activity
                    if let date = formatterIn.date(from: activity.date) {
                        updated.date = formatterOut.string(from: date)
                    }
                    return updated
                }

                DispatchQueue.main.async {
                    completion(decoded)
                }
            } catch {
                print("Decoding error: \(error)")
                completion([])
            }
        }

        task.resume()
    }
}

