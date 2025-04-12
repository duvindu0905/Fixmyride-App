import Foundation

class HomeViewModel: ObservableObject {
    @Published var services: [ServiceModel] = [
        ServiceModel(title: "Car Breakdown", imageName: "car.fill"),
        ServiceModel(title: "Car Repair", imageName: "wrench.and.screwdriver.fill"),
        ServiceModel(title: "Car Wash", imageName: "drop.fill"),
        ServiceModel(title: "Car Modification", imageName: "paintbrush.fill")
    ]
    
    let userName = "Duvindu"
    
    var currentDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE dd MMMM"
        return formatter.string(from: Date()).uppercased()
    }
}

