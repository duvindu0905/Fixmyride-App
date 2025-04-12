import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading) {
                
                Text(viewModel.currentDate)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundColor(.blue)
                    .padding(.top)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text("Good Morning,")
                            .font(.title2)
                            .bold()
                        Text("\(viewModel.userName) !")
                            .font(.title2)
                            .bold()
                    }
                    Spacer()
                    Button(action: {
                        // Handle notifications
                    }) {
                        Image(systemName: "bell.badge.fill")
                            .font(.title2)
                            .padding()
                            .background(Color(.systemGray6))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                .padding(.vertical)
                
                Image("car_service_banner") // Replace with your banner image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 180)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                
                Text("Services")
                    .font(.title3)
                    .bold()
                    .padding(.top)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 20), count: 2), spacing: 20) {
                    ForEach(viewModel.services) { service in
                        VStack {
                            Image(systemName: service.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 80)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                            
                            Text(service.title)
                                .font(.subheadline)
                                .bold()
                                .padding(.top, 4)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 15).stroke(Color.gray))
                    }
                }
                .padding(.vertical)
                
                Spacer()
                
                HStack {
                    TabBarItem(icon: "house.fill", label: "Home")
                    TabBarItem(icon: "magnifyingglass", label: "Search")
                    TabBarItem(icon: "list.bullet.rectangle", label: "Activities")
                    TabBarItem(icon: "person.fill", label: "Profile")
                }
                .padding(.top)
            }
            .padding()
        }
    }
}

struct TabBarItem: View {
    let icon: String
    let label: String
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.title2)
            Text(label)
                .font(.caption)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    HomeView()
}


