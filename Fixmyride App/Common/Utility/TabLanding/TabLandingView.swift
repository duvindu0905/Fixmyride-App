import SwiftUI

struct TabLandingView: View {
    @EnvironmentObject var globalDto: GlobalDto

    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }

            MapView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }

            ActivitiesView()
                .tabItem {
                    Image(systemName: "list.bullet.clipboard")
                    Text("Activities")
                }

            ProfileView()
                .tabItem {
                    Image(systemName: "person.fill")
                    Text("Profile")
                }
        }
        .navigationBarBackButtonHidden(true)
        .accentColor(Color("brandColor")) 
    }
}

#Preview {
    TabLandingView().environmentObject(GlobalDto.shared)
}

