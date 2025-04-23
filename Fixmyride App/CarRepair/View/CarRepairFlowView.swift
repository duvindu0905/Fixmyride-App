import SwiftUI
import MapKit

struct CarRepairFlowView: View {
    @ObservedObject var viewModel = CarRepairViewModel.shared
    @State private var region = MKCoordinateRegion(
          center: CLLocationCoordinate2D(latitude: 37.3349, longitude: -122.0090),
          span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
      )
    @State private var searchTerm: String = ""
    @State private var isSearchFocused: Bool = false
    @State private var showConfirmationToast = false

    var body: some View {
        ZStack {
            CommonBackgroundView()

            VStack(spacing: 16) {
          
                if viewModel.currentStep == 0 {
                    VStack(spacing: 16) {
                        HStack {
                            TitleTextView(text: "Car Repair Types")
                            Spacer()
                        }
                        .padding(.horizontal, UIScreen.main.bounds.width * 0.05)

                        List {
                            Section {
                                CommonSearchBarView(
                                    isFocused: $isSearchFocused,
                                    searchTerm: $searchTerm,
                                    hint: "Search Car Repair Type"
                                )
                            }

                            Section {
                                ForEach(viewModel.repairTypes.filter {
                                    searchTerm.isEmpty ? true : $0.title.localizedCaseInsensitiveContains(searchTerm)
                                }) { type in
                                    Button {
                                        viewModel.selectedRepairType = type
                                        viewModel.currentStep = 1
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


                else if viewModel.currentStep == 1 {
                    VStack(spacing: 16) {
                        HStack {
                            SecondaryHeadingTextView(text: "Appointment Date")
                            Spacer()
                        }

                        DatePicker("Select Date", selection: $viewModel.selectedDate, displayedComponents: .date)
                            .datePickerStyle(.graphical)
                            .padding(.horizontal)

                        SecondaryHeadingTextView(text: "Select Time Slot")

                        let slots = viewModel.getAvailableTimeSlots()
                        List {
                            ForEach(slots.filter { $0.isAvailable }) { slot in
                                Button {
                                    viewModel.selectedTimeSlot = slot.label
                                    viewModel.currentStep = 2
                                } label: {
                                    HStack {
                                        Text(slot.label)
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.gray)
                                    }
                                }
                            }
                        }
                        .listStyle(.plain)
                    }
                }

 
                else if viewModel.currentStep == 2 {
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
                                        buttonText: "Pick Your Location",
                                        backgroundColor: Color("inputBackground"),
                                        foregroundColor: Color("brandColor")
                                    )
                                    .onTapGesture {
                                        viewModel.userLocation = region.center
                                        viewModel.fetchNearbyStations()
                                        viewModel.currentStep = 3
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


                else if viewModel.currentStep == 3 {
                    VStack(spacing: 16) {
                        HStack {
                            SecondaryHeadingTextView(text: "Select a Station")
                            Spacer()
                        }
                        .padding(.horizontal, UIScreen.main.bounds.width * 0.05)

                        List {
                            Section {
                                CommonSearchBarView(
                                    isFocused: $isSearchFocused,
                                    searchTerm: $searchTerm,
                                    hint: "Search Station"
                                )
                                .padding(.vertical, 8)
                            }

                            Section {
                                if viewModel.availableStations.isEmpty {
                                    NormalTextView(text: "No stations found near your location.")
                                        .foregroundColor(.gray)
                                        .padding(.vertical, 8)
                                } else {
                                    ForEach(viewModel.availableStations.filter {
                                        searchTerm.isEmpty ? true : $0.name.localizedCaseInsensitiveContains(searchTerm)
                                    }) { station in
                                        Button {
                                            viewModel.selectedStation = station
                                            viewModel.currentStep = 4
                                        } label: {
                                            CommonNavigationListType2View(
                                                icon: "building.2.fill",
                                                titleText: station.name,
                                                tagText: "Rs. \(Int(station.price)) - \(Int(station.distance)) km",
                                                tagText2: station.isAvailable ? "Available" : "Unavailable",
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

       
                else if viewModel.currentStep == 4 {
                    if let station = viewModel.selectedStation {
                        ScrollView {
                            VStack(alignment: .leading, spacing: 20) {
                                HStack {
                                    Spacer()
                                    SecondaryHeadingTextView(text: "Confirm Booking")
                                    Spacer()
                                }

                                VStack(alignment: .leading, spacing: 12) {
                                    HStack {
                                        Image(systemName: "person.crop.circle.fill")
                                            .resizable()
                                            .frame(width: 40, height: 40)
                                            .foregroundColor(.blue)

                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(station.name)
                                                .fontWeight(.semibold)
                                            Text("\(Int(station.distance)) km away")
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
                                        Text(station.isAvailable ? "Available" : "Unavailable")
                                            .foregroundColor(.green)
                                            .fontWeight(.semibold)
                                    }
                                }
                                .padding()
                                .background(Color.white)
                                .cornerRadius(20)
                                .shadow(radius: 4)

                                VStack(alignment: .leading, spacing: 12) {
                                    Text("Booking Summary")
                                        .fontWeight(.bold)

                                    HStack {
                                        Text("Service Type")
                                        Spacer()
                                        Text(viewModel.selectedRepairType?.title ?? "")
                                            .foregroundColor(.blue)
                                    }

                                    HStack {
                                        Text("Date")
                                        Spacer()
                                        Text(viewModel.selectedDate.formatted(date: .numeric, time: .omitted))
                                            .foregroundColor(.blue)
                                    }

                                    HStack {
                                        Text("Time Slot")
                                        Spacer()
                                        Text(viewModel.selectedTimeSlot ?? "")
                                            .foregroundColor(.blue)
                                    }

                                    HStack {
                                        Text("Service Cost")
                                        Spacer()
                                        Text("Rs. \(Int(station.price))")
                                            .foregroundColor(.blue)
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
                                    LocalNotificationManager.shared.requestPermission()
                                    LocalNotificationManager.shared.scheduleNotification(
                                        title: "Car Repair Booking Confirmed!",
                                        body: "Station: \(station.name) at your service."
                                    )

                                    withAnimation {
                                        showConfirmationToast = true
                                    }

                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                        withAnimation {
                                            showConfirmationToast = false
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
    CarRepairFlowView().environmentObject(GlobalDto.shared)
}

