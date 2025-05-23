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
      
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        SecondaryHeadingTextView(
                            text: "MONDAY 26 FEBRUARY",
                            foregroundColor: Color("commonTextColor"),
                            weight: .heavy,
                            font: .callout
                        )
                        TitleTextView(text: "Good Morning!")
                    }

                    Spacer()

                    HStack(spacing: 12) {
                        Button {
                            globalDto.paths.append(Route.notification.rawValue)
                        } label: {
                            NotificationButtonView(
                                icon: "bell.fill",
                                iconColor: Color("brandColor")
                            )
                        }

                        Button {
                            globalDto.paths.append(Route.emergency.rawValue)
                        } label: {
                            EmergencyButtonView(
                                icon: "phone.fill",
                                iconColor: .red
                            )
                        }
                    }
                }

   
                ScrollView {
                    VStack(spacing: 24) {
            
                        Image("main_banner")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 180)
                            .clipShape(RoundedRectangle(cornerRadius: 16))

                        
                        VStack(alignment: .leading, spacing: 16) {
                            TitleTextView(text: "Services")

                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                                ForEach(services) { service in
                                    Button {
                                        switch service.title {
                                        case "Car Breakdown":
                                            globalDto.paths.append(Route.breakdown.rawValue)

                                        case "Car Repair":
                                            globalDto.paths.append(Route.carRepair.rawValue)

                                        case "Car Wash":
                                            globalDto.paths.append(Route.carWash.rawValue)

                                        case "Car Modification":
                                            globalDto.paths.append(Route.arCarModification.rawValue)

                                        default:
                                            break
                                        }
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

