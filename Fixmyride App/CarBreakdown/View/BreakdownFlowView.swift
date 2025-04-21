import SwiftUI
import MapKit

struct BreakdownFlowView: View {
    @ObservedObject var viewModel = BreakdownViewModel.shared
    @State private var currentStep = 0
    @State private var searchTerm: String = ""
    @State private var isSearchFocused: Bool = false
    @State private var showConfirmationToast = false
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 6.9271, longitude: 79.8612),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    let types: [BreakdownType] = [
        .init(title: "Jump Start Only", iconName: "bolt.car"),
        .init(title: "Carrier", iconName: "car.2.fill"),
        .init(title: "Scanning", iconName: "wrench.fill")
    ]
    
    var body: some View {
        ZStack {
            CommonBackgroundView()
            
            VStack(spacing: 16) {
                if currentStep == 0 {
                    VStack(spacing: 16) {
                        HStack {
                            TitleTextView(text: "Breakdown Types")
                            Spacer()
                        }
                        .padding(.horizontal, UIScreen.main.bounds.width * 0.05)
                        
                        List {
                            Section {
                                CommonSearchBarView(
                                    isFocused: $isSearchFocused,
                                    searchTerm: $searchTerm,
                                    hint: "Search Breakdown Type"
                                )
                            }
                            
                            Section {
                                ForEach(types.filter {
                                    searchTerm.isEmpty ? true : $0.title.localizedCaseInsensitiveContains(searchTerm)
                                }) { type in
                                    Button {
                                        viewModel.selectedType = type
                                        currentStep = 1
                                    } label: {
                                        HStack {
                                            Image(systemName: type.iconName)
                                                .foregroundColor(.blue)
                                            Text(type.title)
                                            Spacer()
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(.gray)
                                        }
                                        .padding(.vertical, 10)
                                    }
                                }
                            }
                        }
                        .listStyle(.insetGrouped)
                    }
                    .padding(.top, 16)
                }
                
                
                else if currentStep == 1 {
                    VStack(spacing: 16) {
                        HStack {
                            SecondaryHeadingTextView(text: "Pickup Location")
                            Spacer()
                        }
                        .padding(.horizontal, UIScreen.main.bounds.width * 0.05)
                        
                        List {
                            Section {
                                Map(coordinateRegion: $region, showsUserLocation: true)
                                    .frame(height: 250)
                                    .cornerRadius(12)
                            }
                            
                            Section {
                                VStack(alignment: .leading, spacing: 8) {
                                    NormalTextView(text: "Enter Pickup Location")
                                    
                                    CommonSearchBarView(
                                        isFocused: $isSearchFocused,
                                        searchTerm: $searchTerm,
                                        hint: "Search Pickup Location"
                                    )
                                    
                                    CommonButtonView(
                                        buttonText: "Pick This Location",
                                        backgroundColor: Color("inputBackground"),
                                        foregroundColor: Color("brandColor")
                                    )
                                    .onTapGesture {
                                        viewModel.userLocation = region.center
                                        viewModel.fetchNearbyMechanics()
                                        currentStep = 2
                                    }
                                    .padding(.top, 8)
                                }
                                .padding(.vertical, 8)
                            }
                        }
                        .listStyle(.insetGrouped)
                        .scrollDisabled(true)
                    }
                    .padding(.top, 16)
                }
                
                
                else if currentStep == 2 {
                    VStack(spacing: 16) {
                        HStack {
                            SecondaryHeadingTextView(text: "Select a Mechanic")
                            Spacer()
                        }
                        .padding(.horizontal, UIScreen.main.bounds.width * 0.05)
                        
                        List {
                            Section {
                                CommonSearchBarView(
                                    isFocused: $isSearchFocused,
                                    searchTerm: $searchTerm,
                                    hint: "Search Mechanic"
                                )
                                .padding(.vertical, 8)
                            }
                            
                            Section {
                                if viewModel.availableMechanics.isEmpty {
                                    NormalTextView(text: "No mechanics found near your location.")
                                        .foregroundColor(.gray)
                                        .padding(.vertical, 8)
                                } else {
                                    ForEach(viewModel.availableMechanics.filter {
                                        searchTerm.isEmpty ? true : $0.name.localizedCaseInsensitiveContains(searchTerm)
                                    }) { mechanic in
                                        Button {
                                            viewModel.selectedMechanic = mechanic
                                            currentStep = 3
                                        } label: {
                                            CommonNavigationListType2View(
                                                icon: "wrench.fill",
                                                titleText: mechanic.name,
                                                tagText: "Rs. \(Int(mechanic.price)) - \(Int(mechanic.distance)) km",
                                                tagText2: mechanic.isAvailable ? "Available" : "Unavailable",
                                                size: 0.06
                                            )
                                        }
                                    }
                                }
                            }
                        }
                        .listStyle(.insetGrouped)
                    }
                    .padding(.top, 16)
                }
                
                
                else if currentStep == 3 {
                    if let mechanic = viewModel.selectedMechanic {
                        ZStack {
                            CommonBackgroundView()

                            ScrollView {
                                VStack(alignment: .leading, spacing: 20) {
                                    HStack {
                                        Spacer()
                                        SecondaryHeadingTextView(text: "Confirm Booking")
                                        Spacer()
                                    }

                                    Spacer()

                                    VStack(alignment: .leading, spacing: 12) {
                                        HStack {
                                            Image(systemName: "person.crop.circle.fill")
                                                .resizable()
                                                .frame(width: 40, height: 40)
                                                .foregroundColor(.blue)

                                            VStack(alignment: .leading, spacing: 4) {
                                                Text(mechanic.name)
                                                    .fontWeight(.semibold)
                                                Text("\(Int(mechanic.distance)) km away")
                                                    .font(.subheadline)
                                                    .foregroundColor(.gray)
                                                Text("View Location")
                                                    .font(.footnote)
                                                    .foregroundColor(.red)
                                            }

                                            Spacer()
                                        }

                                        Divider()

                                        HStack {
                                            Text("Contact")
                                                .fontWeight(.medium)
                                            Spacer()
                                            Image(systemName: "phone.fill")
                                                .foregroundColor(.red)
                                        }

                                        HStack {
                                            Text("Availability")
                                                .fontWeight(.medium)
                                            Spacer()
                                            Text(mechanic.isAvailable ? "Available" : "Unavailable")
                                                .foregroundColor(.green)
                                                .fontWeight(.semibold)
                                        }
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(20)
                                    .shadow(radius: 4)

                                    Spacer()

                                    VStack(alignment: .leading, spacing: 12) {
                                        Text("Booking Summary")
                                            .fontWeight(.bold)

                                        HStack {
                                            Text("Service Type")
                                            Spacer()
                                            Text(viewModel.selectedType?.title ?? "")
                                                .foregroundColor(.gray)
                                        }

                                        HStack {
                                            Text("Date")
                                            Spacer()
                                            Text(viewModel.selectedDate.formatted(date: .numeric, time: .omitted))
                                                .foregroundColor(.gray)
                                        }

                                        HStack {
                                            Text("Service Cost")
                                            Spacer()
                                            Text("Rs. \(Int(mechanic.price))")
                                                .foregroundColor(.gray)
                                        }
                                    }
                                    .padding()
                                    .background(Color.white)
                                    .cornerRadius(20)
                                    .shadow(radius: 4)

                                    CommonButtonView(
                                        buttonText: "Confirm Booking",
                                        backgroundColor: Color("inputBackground"),
                                        foregroundColor: Color.blue
                                    )
                                    .padding(.top, 12)
                                    .onTapGesture {
                                        viewModel.postBooking(mechanic: mechanic) { success in
                                            if success {
                                                LocalNotificationManager.shared.scheduleNotification(
                                                    title: "Booking Confirmed!",
                                                    body: "Mechanic: \(mechanic.name) at your service."
                                                )

                                                withAnimation {
                                                    showConfirmationToast = true
                                                }

                                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                                    withAnimation {
                                                        showConfirmationToast = false
                                                        currentStep = 0
                                                    }
                                                }
                                            } else {
                                                print("❌ Booking creation failed.")
                                            }
                                        }
                                    }

                                    Spacer()
                                }
                                .padding(.horizontal, UIScreen.main.bounds.width * 0.05)
                                .padding(.top, 16)
                            }
                        }
                    }
                }

                }
                
            
                if showConfirmationToast {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Text("✅ Booking confirmed!")
                                .foregroundColor(.white)
                                .fontWeight(.medium)
                                .padding(.vertical, 12)
                                .padding(.horizontal, 24)
                                .background(Color.green)
                                .cornerRadius(20)
                            Spacer()
                        }
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .padding(.bottom, 40)
                    }
                    .animation(.easeInOut, value: showConfirmationToast)
                }
            }
        }
    }

#Preview {
    BreakdownFlowView().environmentObject(GlobalDto.shared)
}

