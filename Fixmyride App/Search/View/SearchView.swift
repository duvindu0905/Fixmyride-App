import SwiftUI
import MapKit

struct MapView: View {
    @EnvironmentObject var globalDto: GlobalDto
    @ObservedObject var viewModel = MapViewModel.shared

    let locationManager = CLLocationManager()

    @State private var lookAroundScene: MKLookAroundScene?
    @State private var isShowingLookAroundScene = false
    @State private var selectedGarage: GarageModel?
    @State private var isShowingNavigationSheet = false
    @State private var isShowingHomeSheet = true
    @State private var isSearchBarFocused = false
    @State private var searchTerm = ""

    let gridItems = [GridItem(.flexible()), GridItem(.flexible())]

    @State private var route: MKRoute?
    @State private var distance: Double?
    @State private var estimatedTime: Int?
    @State private var steps: [MKRoute.Step]?

    private var filteredSearches: [GarageModel] {
        if searchTerm.isEmpty {
            return viewModel.garages
        } else {
            return viewModel.garages.filter {
                $0.name.localizedCaseInsensitiveContains(searchTerm)
            }
        }
    }

    var body: some View {
        Map {
            ForEach(viewModel.garages) { garage in
                Annotation(garage.name,
                           coordinate: CLLocationCoordinate2D(latitude: garage.latitude, longitude: garage.longitude),
                           anchor: .bottom) {
                    Button {
                        selectedGarage = garage
                    } label: {
                        CommonAnnotationView(backgroundColor: .blue, icon: "wrench.fill")
                    }
                }
            }

            UserAnnotation()

            if let route {
                MapPolyline(route).stroke(.red, lineWidth: 6)
            }
        }
        .tint(Color("brandColor"))
        .mapControls {
            MapUserLocationButton()
            MapCompass()
            MapPitchToggle()
            MapScaleView()
        }
        .mapStyle(.standard(elevation: .realistic))
        .lookAroundViewer(isPresented: $isShowingLookAroundScene, initialScene: lookAroundScene)
        .onAppear {
            locationManager.requestWhenInUseAuthorization()
            viewModel.fetchGarages()

            if globalDto.comingFrom == Route.garage.rawValue {
                isShowingHomeSheet = false
                globalDto.comingFrom = ""
            } else {
                isShowingHomeSheet = true
            }
        }
        .sheet(isPresented: $isShowingHomeSheet) {
            searchSheetView
        }
        .sheet(isPresented: $isShowingNavigationSheet) {
            directionsSheetView
        }
        .sheet(item: $selectedGarage) { garage in
            garageDetailSheet(garage: garage)
        }
    }

    private var searchSheetView: some View {
        Group {
            if isSearchBarFocused {
                VStack {
                    CommonSearchBarView(isFocused: $isSearchBarFocused, searchTerm: $searchTerm, hint: "Search garages")
                        .padding(.horizontal, UIScreen.main.bounds.width * 0.05)

                    List {
                        ScrollView {
                            ForEach(filteredSearches) { garage in
                                Button {
                                    isShowingHomeSheet = false
                                    selectedGarage = garage
                                } label: {
                                    garageListTile(garage)
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                    .padding(.top, 32)

                    Spacer()
                }
                .presentationDetents([.large])
                .ignoresSafeArea()
                .padding(.top, 16)
                .background(.white)
            } else {
                VStack {
                    CommonSearchBarView(isFocused: $isSearchBarFocused, searchTerm: $searchTerm, hint: "Search garages")

                    HStack {
                        NormalTextView(text: "Latest searches", multilineTextAlignment: .leading)
                        Spacer()
                    }

                    ScrollView {
                        LazyVGrid(columns: gridItems) {
                            ForEach(filteredSearches) { garage in
                                if let firstUrl = garage.imageUrls?.first {
                                    CommonEventCardView(title: garage.name, day: garage.name, imageUrl: firstUrl)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, UIScreen.main.bounds.width * 0.05)

                    Spacer()
                }
                .presentationDetents([.medium, .large])
                .ignoresSafeArea()
                .padding(.top, 16)
                .background(Color("commonBackground"))
            }
        }
    }

    private func garageListTile(_ garage: GarageModel) -> some View {
        let icon: String
        switch garage.type {
        case .repairCenter: icon = "wrench.fill"
        case .engineering: icon = "gearshape.fill"
        case .detailing: icon = "sparkles"
        case .painting: icon = "paintbrush.fill"
        }

        return CommonNavigationListType2View(
            icon: icon,
            titleText: garage.name,
            tagText: garage.address,
            tagText2: "",
            size: 0.06
        )
    }

    private var directionsSheetView: some View {
        VStack {
            HStack {
                SecondaryHeadingTextView(text: "Directions")
                Spacer()
                Button { isShowingNavigationSheet = false } label: {
                    CommonIconButtonView(icon: "xmark")
                }
            }
            .padding(.horizontal, UIScreen.main.bounds.width * 0.05)

            List {
                CommonStaticListView(
                    icon: "app.connected.to.app.below.fill",
                    titleText: "(\(Int(distance ?? 0)) m)",
                    valueText: "\(estimatedTime ?? 0) min"
                )
            }
            .frame(maxHeight: 100)

            List {
                if let steps {
                    ForEach(steps, id: \.self) { step in
                        CommonStaticListView(icon: "checkmark.circle.fill", titleText: step.instructions, valueText: "")
                    }
                }
            }

            Spacer()
        }
        .presentationDetents([.medium, .large])
        .ignoresSafeArea()
        .padding(.top, 16)
        .background(Color("commonBackground"))
    }

    private func garageDetailSheet(garage: GarageModel) -> some View {
        VStack(spacing: 16) {
            HStack {
                SecondaryHeadingTextView(text: garage.name)
                Spacer()
                Button {
                    Task {
                        lookAroundScene = await getLookAroundScene(coordinate: CLLocationCoordinate2D(latitude: garage.latitude, longitude: garage.longitude))
                        isShowingLookAroundScene = lookAroundScene != nil
                    }
                } label: {
                    CommonIconButtonView(icon: "dot.viewfinder")
                }

                Button { selectedGarage = nil } label: {
                    CommonIconButtonView(icon: "xmark")
                }
            }

            NormalTextView(text: garage.address, multilineTextAlignment: .leading)

            Button {
                getDirection(destination: CLLocationCoordinate2D(latitude: garage.latitude, longitude: garage.longitude))
                isShowingNavigationSheet = true
            } label: {
                CommonButtonView(buttonText: "Show Me Direction", backgroundColor: Color("inputBackground"), foregroundColor: Color("brandColor"))
            }

            AvailabilityCardView(
                availabilityValueInDouble: garage.availabilityInDouble,
                availabilityValueInString: garage.availabilityInString.rawValue
            )

            if let imageUrls = garage.imageUrls {
                ScrollView {
                    LazyVGrid(columns: gridItems) {
                        ForEach(imageUrls, id: \.self) { url in
                            CommonSquareImageView(url: url)
                        }
                    }
                }
            }

            Spacer()
        }
        .padding(.horizontal, UIScreen.main.bounds.width * 0.05)
        .presentationDetents([.medium, .large])
        .background(Color("commonBackground"))
    }

    func getDirection(destination: CLLocationCoordinate2D) {
        Task {
            guard let userLocation = await getUserLocation() else { return }

            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: .init(coordinate: userLocation))
            request.destination = MKMapItem(placemark: .init(coordinate: destination))
            request.transportType = .walking

            do {
                let directions = try await MKDirections(request: request).calculate()
                if let route = directions.routes.first {
                    self.route = route
                    self.distance = route.distance
                    self.estimatedTime = Int(route.expectedTravelTime / 60)
                    self.steps = route.steps
                }
            } catch {
                print("cannot get route \(error)")
            }
        }
    }

    func getUserLocation() async -> CLLocationCoordinate2D? {
        let updates = CLLocationUpdate.liveUpdates()
        do {
            let update = try await updates.first { $0.location?.coordinate != nil }
            return update?.location?.coordinate
        } catch {
            print("cannot get user location")
            return nil
        }
    }

    func getLookAroundScene(coordinate: CLLocationCoordinate2D) async -> MKLookAroundScene? {
        do {
            return try await MKLookAroundSceneRequest(coordinate: coordinate).scene
        } catch {
            print("Cannot get look around scene")
            return nil
        }
    }
}

#Preview {
    MapView()
        .environmentObject(GlobalDto.shared)
}

