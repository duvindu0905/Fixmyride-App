import SwiftUI

struct HomeView: View {
    @EnvironmentObject var globalDto: GlobalDto

    let services: [ServiceModel] = [
        ServiceModel(title: "Car Breakdown", imageName: "car_breakdown"),
        ServiceModel(title: "Car Repair", imageName: "car_repair"),
        ServiceModel(title: "Car Wash", imageName: "car_wash"),
        ServiceModel(title: "Car Modification", imageName: "car_modification")
    ]

    var body: some View {
        ZStack {
            CommonBackgroundView()

            VStack {
                // Top Bar
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        SecondaryHeadingTextView(
                            text: "MONDAY 10 FEBRUARY",
                            foregroundColor: Color("commonTextColor"),
                            weight: .heavy,
                            font: .callout
                        )
                        TitleTextView(text: "Good Morning!")
                    }

                    Spacer()

                    Button {
                        globalDto.paths.append(Route.notification.rawValue)
                    } label: {
                        NotificationButtonView(
                            icon: "bell.fill",
                            iconColor: Color("brandColor")
                        )
                    }
                }

                ScrollView {
                    VStack(spacing: 24) {

                        // Banner
                        Image("main_banner")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 180)
                            .clipShape(RoundedRectangle(cornerRadius: 16))

                        // Services Section
                        VStack(alignment: .leading, spacing: 16) {
                            TitleTextView(text: "Services")

                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                                ForEach(services) { service in
                                    Button {
                                        print("Tapped \(service.title)")
                                        // Example: Navigate somewhere
                                        // globalDto.paths.append(Route.booking.rawValue)
                                    } label: {
                                        VStack(spacing: 8) {
                                            Image(service.imageName)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(height: 100)
                                                .frame(maxWidth: .infinity)
                                                .clipped()
                                                .cornerRadius(12)

                                            Text(service.title)
                                                .font(.subheadline)
                                                .bold()
                                                .foregroundColor(.black)
                                        }
                                        .padding(8)
                                        .background(Color.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                        .shadow(radius: 1)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.bottom, 80)
                }
            }
            .padding(.top, 32)
            .padding(.horizontal, UIScreen.main.bounds.width * 0.05)
        }
    }
}

#Preview {
    HomeView().environmentObject(GlobalDto.shared)
}


