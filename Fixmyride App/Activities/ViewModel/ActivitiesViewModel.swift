import SwiftUI

class ActivitiesViewModel: ObservableObject {
    static let shared = ActivitiesViewModel()

    @Published var activities: [ActivityModel] = []

    private init() {}

    func getCompletedActivities(completion: @escaping ([ActivityModel]) -> Void) {
        guard let url = URL(string: "https://4wxr949qfc.execute-api.ap-southeast-1.amazonaws.com/live/api/activities/completed") else {
            print("❌ Invalid Completed URL")
            completion([])
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("❌ Error: \(error?.localizedDescription ?? "Unknown error")")
                completion([])
                return
            }

            do {
                var decoded = try JSONDecoder().decode([ActivityModel].self, from: data)

             
                let formatterIn = DateFormatter()
                formatterIn.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                formatterIn.timeZone = TimeZone(secondsFromGMT: 0)

                let formatterOut = DateFormatter()
                formatterOut.dateFormat = "dd MMM yyyy hh:mm a"
                formatterOut.timeZone = TimeZone(identifier: "Asia/Colombo")

                decoded = decoded.map { activity in
                    var updated = activity
                    if let isoDate = formatterIn.date(from: activity.date) {
                        updated.date = formatterOut.string(from: isoDate)
                    } else {
                        print("❌ Failed to format date: \(activity.date)")
                    }
                    return updated
                }

                DispatchQueue.main.async {
                    completion(decoded)
                }

            } catch {
                print("❌ Decoding error: \(error)")
                completion([])
            }
        }.resume()
    }

    func getUpcomingActivities(completion: @escaping ([ActivityModel]) -> Void) {
        guard let url = URL(string: "https://4wxr949qfc.execute-api.ap-southeast-1.amazonaws.com/live/api/breakdown/bookings/upcoming") else {
            print("❌ Invalid Upcoming URL")
            completion([])
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("❌ Error: \(error?.localizedDescription ?? "Unknown error")")
                completion([])
                return
            }

            do {
                struct APIResponse: Decodable {
                    let success: Bool
                    let data: [ActivityModel]
                }

                let decoded = try JSONDecoder().decode(APIResponse.self, from: data)
                var activities = decoded.data

                
                let formatterIn = DateFormatter()
                formatterIn.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                formatterIn.timeZone = TimeZone(secondsFromGMT: 0)

                let formatterOut = DateFormatter()
                formatterOut.dateFormat = "dd MMM yyyy hh:mm a"
                formatterOut.timeZone = TimeZone(identifier: "Asia/Colombo")

                activities = activities.map { activity in
                    var updated = activity
                    if let isoDate = formatterIn.date(from: activity.date) {
                        updated.date = formatterOut.string(from: isoDate)
                    } else {
                        print("❌ Failed to format date: \(activity.date)")
                    }
                    return updated
                }

                DispatchQueue.main.async {
                    completion(activities)
                }

            } catch {
                print("❌ Decoding error: \(error)")
                completion([])
            }
        }.resume()
    }
}

