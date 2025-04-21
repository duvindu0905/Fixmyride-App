import SwiftUI

class ActivitiesViewModel: ObservableObject {
    static let shared = ActivitiesViewModel()

    @Published var activities: [ActivityModel] = []

    private init() {}

    // MARK: - Completed Activities
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
                decoded = decoded.map { self.formatActivityDate($0) }

                DispatchQueue.main.async {
                    completion(decoded)
                }

            } catch {
                print("❌ Decoding error: \(error)")
                completion([])
            }
        }.resume()
    }

    // MARK: - Upcoming Activities
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
                let activities = decoded.data.map { self.formatActivityDate($0) }

                DispatchQueue.main.async {
                    completion(activities)
                }

            } catch {
                print("❌ Decoding error: \(error)")
                completion([])
            }
        }.resume()
    }

    // MARK: - Date Formatting Helper
    private func formatActivityDate(_ activity: ActivityModel) -> ActivityModel {
        var updated = activity

        let isoFormatter = DateFormatter()
        isoFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        isoFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        let jsFormatter = DateFormatter()
        jsFormatter.dateFormat = "EEE MMM dd yyyy HH:mm:ss 'GMT'Z (zzzz)"
        jsFormatter.locale = Locale(identifier: "en_US_POSIX")
        jsFormatter.timeZone = TimeZone(secondsFromGMT: 0)

        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "dd MMM yyyy hh:mm a"
        displayFormatter.timeZone = TimeZone(identifier: "Asia/Colombo")

        if let date = isoFormatter.date(from: updated.date) {
            updated.date = displayFormatter.string(from: date)
        } else if let date = jsFormatter.date(from: updated.date) {
            updated.date = displayFormatter.string(from: date)
        } else if let date = displayFormatter.date(from: updated.date) {
            updated.date = displayFormatter.string(from: date)
        } else {
            print("❌ Could not parse: \(updated.date)")
            // updated.date = updated.date ← REMOVE this line
        }


        return updated
    }
}

