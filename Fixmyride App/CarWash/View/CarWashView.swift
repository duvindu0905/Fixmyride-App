import SwiftUI
import MapKit

struct CarWashFlowView: View {
    @ObservedObject var viewModel = CarWashViewModel.shared


    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 6.9271, longitude: 79.8612),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )

   
    @State private var searchTerm        = ""
    @State private var isSearchFocused   = false
    @State private var showConfirmation  = false

    var body: some View {
        ZStack {
            CommonBackgroundView()

            VStack(spacing: 16) {
                switch viewModel.currentStep {

              
                case 0: washTypeStep

                
                case 1: scheduleStep

                
                case 2: pickupLocationStep

             
                case 3: stationSelectionStep

               
                case 4: confirmationStep

                default: EmptyView()
                }
            }


            if showConfirmation { toast }
        }
    }
}


private extension CarWashFlowView {
    var washTypeStep: some View {
        VStack(spacing: 16) {
            HStack {
                TitleTextView(text: "Car Wash Types")
                Spacer()
            }

            List {
                Section {
                    CommonSearchBarView(
                        isFocused: $isSearchFocused,
                        searchTerm: $searchTerm,
                        hint: "Search Car Wash Type"
                    )
                }

                Section {
                    ForEach(viewModel.washTypes.filter {
                        searchTerm.isEmpty
                        ? true
                        : $0.title.localizedCaseInsensitiveContains(searchTerm)
                    }) { type in
                        Button {
                            viewModel.selectedWashType = type
                            viewModel.currentStep = 1
                        } label: {
                            HStack {
                                Image(systemName: type.iconName).foregroundColor(.blue)
                                Text(type.title)
                                Spacer()
                                Image(systemName: "chevron.right").foregroundColor(.gray)
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
}


private extension CarWashFlowView {
    var scheduleStep: some View {
        VStack(spacing: 16) {
            SecondaryHeadingTextView(text: "Select Date")
            DatePicker(
                "Appointment Date",
                selection: $viewModel.selectedDate,
                displayedComponents: .date
            )
            .datePickerStyle(.graphical)
            .padding(.horizontal)

            SecondaryHeadingTextView(text: "Select Time Slot")
            List {
                ForEach(viewModel.getAvailableTimeSlots().filter { $0.isAvailable }) { slot in
                    Button {
                        viewModel.selectedTimeSlot = slot.label
                        viewModel.currentStep = 2
                    } label: {
                        HStack {
                            Text(slot.label)
                            Spacer()
                            Image(systemName: "chevron.right").foregroundColor(.gray)
                        }
                    }
                }
            }
            .listStyle(.plain)
        }
    }
}


private extension CarWashFlowView {
    var pickupLocationStep: some View {
        VStack(spacing: 16) {
            SecondaryHeadingTextView(text: "Pickup Location")

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
}


private extension CarWashFlowView {
    var stationSelectionStep: some View {
        VStack(spacing: 16) {
            SecondaryHeadingTextView(text: "Select a Station")

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
                            searchTerm.isEmpty
                            ? true
                            : $0.name.localizedCaseInsensitiveContains(searchTerm)
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
}


private extension CarWashFlowView {
    @ViewBuilder
    var confirmationStep: some View {
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
                                Text(station.name).fontWeight(.semibold)
                                Text("\(Int(station.distance)) km away")
                                    .font(.subheadline).foregroundColor(.gray)
                                Text("View Location")
                                    .font(.footnote).foregroundColor(.red)
                            }

                            Spacer()
                        }

                        Divider()

                        HStack {
                            Text("Contact").fontWeight(.medium)
                            Spacer()
                            Image(systemName: "phone.fill").foregroundColor(.red)
                        }

                        HStack {
                            Text("Availability").fontWeight(.medium)
                            Spacer()
                            Text(station.isAvailable ? "Available" : "Unavailable")
                                .foregroundColor(.green).fontWeight(.semibold)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 4)

              
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Booking Summary").fontWeight(.bold)

                        HStack {
                            Text("Service Type")
                            Spacer()
                            Text(viewModel.selectedWashType?.title ?? "")
                                .foregroundColor(.gray)
                        }

                        HStack {
                            Text("Date")
                            Spacer()
                            Text(viewModel.selectedDate.formatted(date: .numeric, time: .omitted))
                                .foregroundColor(.gray)
                        }

                        HStack {
                            Text("Time Slot")
                            Spacer()
                            Text(viewModel.selectedTimeSlot)
                                .foregroundColor(.gray)
                        }

                        HStack {
                            Text("Service Cost")
                            Spacer()
                            Text("Rs. \(Int(station.price))")
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
                        LocalNotificationManager.shared.requestPermission()
                        LocalNotificationManager.shared.scheduleNotification(
                            title: "Car Wash Booking Confirmed!",
                            body: "Station: \(station.name) at your service."
                        )

                        withAnimation { showConfirmation = true }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                            withAnimation { showConfirmation = false }
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


private extension CarWashFlowView {
    var toast: some View {
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
        .animation(.easeInOut, value: showConfirmation)
    }
}

#Preview {
    CarWashFlowView().environmentObject(GlobalDto.shared)
}

