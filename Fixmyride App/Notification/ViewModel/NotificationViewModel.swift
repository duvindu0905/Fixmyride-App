import SwiftUI

class NotificationViewModel: ObservableObject {
    static let shared = NotificationViewModel()

    @Published var notifications: [NotificationModel] = []

    private init() {}

    func getNotification(completion: @escaping ([NotificationModel]) -> Void) {
        guard let url = URL(string: "https://4wxr949qfc.execute-api.ap-southeast-1.amazonaws.com/live/api/notifications") else {
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
                var decoded = try JSONDecoder().decode([NotificationModel].self, from: data)

                let formatterIn = ISO8601DateFormatter()
                let formatterOut = DateFormatter()
                formatterOut.dateFormat = "yyyy-MM-dd"

                decoded = decoded.map { notif in
                    var updated = notif
                    if let date = formatterIn.date(from: notif.day) {
                        updated.day = formatterOut.string(from: date)
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

