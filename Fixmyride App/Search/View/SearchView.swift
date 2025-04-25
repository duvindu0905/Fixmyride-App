import MapKit
import SwiftUI

// Displays the map with user location, garage annotations, and interactive sheets.
struct MapView: View {
    @EnvironmentObject var globalDto: GlobalDto
    @ObservedObject var viewModel = MapViewModel.shared

    // Handles location permission
    let locationManager = CLLocationManager()

    // State for Look Around feature
    @State private var lookAroundScene: MKLookAroundScene?
    @State private var isShowingLookAroundScene = false

    // Currently selected garage
    @State private var selectedGarage: GarageModel?

    // Sheet state controllers
    @State private var isShowingNavigationSheet = false
    @State private var isShowingHomeSheet = true
    @State private var isSearchBarFocused = false

    // Search bar input
    @State private var searchTerm = ""

    // Layout config for garage thumbnails
    let gridItems = [GridItem(.flexible()), GridItem(.flexible())]

    // Route and directions info
    @State private var route: MKRoute?
    @State private var distance: Double?
    @State private var estimatedTime: Int?
    @State private var steps: [MKRoute.Step]?

    // Filters garages based on search term
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
            // Garage Annotations
            ForEach(viewModel.garages) { garage in
                Annotation(
                    garage.name,
                    coordinate: CLLocationCoordinate2D(
                        latitude: garage.latitude,
                        longitude: garage.longitude
                    ),
                    anchor: .bottom
                ) {
                    Button {
                        selectedGarage = garage
                    } label: {
                        CommonAnnotationView(
                            backgroundColor: .blue,
                            icon: "wrench.fill"
                        )
                    }
                }
            }

            // User Location Annotation
            UserAnnotation()

            // Route Polyline (if available)
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
        .lookAroundViewer(
            isPresented: $isShowingLookAroundScene,
            initialScene: lookAroundScene
        )
        .onAppear {
            locationManager.requestWhenInUseAuthorization()
            viewModel.fetchGarages()

            // Handles navigation flow reset
            if globalDto.comingFrom == Route.garage.rawValue {
                isShowingHomeSheet = false
                globalDto.comingFrom = ""
            } else {
                isShowingHomeSheet = true
            }
        }
        // Sheet: Home Search Sheet
        .sheet(isPresented: $isShowingHomeSheet) {
            searchSheetView
        }
        // Sheet: Navigation directions
        .sheet(isPresented: $isShowingNavigationSheet) {
            directionsSheetView
        }
        // Sheet: Garage Detail View
        .sheet(item: $selectedGarage) { garage in
            garageDetailSheet(garage: garage)
        }
    }

    // View for search & garage grid/list
    private var searchSheetView: some View {
        Group {
            if isSearchBarFocused {
                // List View while search bar is focused
                VStack {
                    VStack(spacing: 16) {
                        CommonSearchBarView(
                            isFocused: $isSearchBarFocused,
                            searchTerm: $searchTerm,
                            hint: "Search garages"
                        )
                    }
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
                // Grid View when search is inactive
                VStack {
                    VStack(spacing: 16) {
                        CommonSearchBarView(
                            isFocused: $isSearchBarFocused,
                            searchTerm: $searchTerm,
                            hint: "Search garages"
                        ).padding(
                            .horizontal,
                            UIScreen.main.bounds.width * 0.05
                        )
                    }
                    HStack {
                        NormalTextView(
                            text: "Latest searches",
                            multilineTextAlignment: .leading
                        ).padding(
                            .horizontal,
                            UIScreen.main.bounds.width * 0.05
                        )
                        Spacer()
                    }

                    ScrollView {
                        LazyVGrid(columns: gridItems) {
                            ForEach(filteredSearches) { garage in
                                if let firstUrl = garage.imageUrls?.first {
                                    CommonEventCardView(
                                        title: garage.name,
                                        day: garage.name,
                                        imageUrl: firstUrl
                                    )
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

    // Returns a UI list tile for a garage based on its type
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

    // Directions view with route steps and estimated time
    private var directionsSheetView: some View {
        VStack {
            HStack {
                SecondaryHeadingTextView(text: "Directions")
                Spacer()
                Button {
                    isShowingNavigationSheet = false
                } label: {
                    CommonIconButtonView(icon: "xmark")
                }
            }
            .padding(.horizontal, UIScreen.main.bounds.width * 0.05)

            // Distance & Time
            List {
                CommonStaticListView(
                    icon: "app.connected.to.app.below.fill",
                    titleText: "(\(Int(distance ?? 0)) m)",
                    valueText: "\(estimatedTime ?? 0) min"
                )
            }
            .frame(maxHeight: 100)

            // Route Step Instructions
            List {
                if let steps {
                    ForEach(steps, id: \.self) { step in
                        CommonStaticListView(
                            icon: "checkmark.circle.fill",
                            titleText: step.instructions,
                            valueText: ""
                        )
                    }
                }
            }
            .contentMargins(.vertical, 0)
            Spacer()
        }
        .presentationDetents([.medium, .large])
        .ignoresSafeArea()
        .padding(.top, 16)
        .background(Color("commonBackground"))
    }

    // Garage detail view with look around and direction buttons
    private func garageDetailSheet(garage: GarageModel) -> some View {
        VStack(spacing: 16) {
            HStack {
                SecondaryHeadingTextView(text: garage.name).padding(
                    .horizontal,
                    UIScreen.main.bounds.width * 0.05
                )
                Spacer()

                // Look Around button
                Button {
                    Task {
                        lookAroundScene = await getLookAroundScene(
                            coordinate: CLLocationCoordinate2D(
                                latitude: garage.latitude,
                                longitude: garage.longitude
                            )
                        )
                        isShowingLookAroundScene = lookAroundScene != nil
                    }
                } label: {
                    CommonIconButtonView(icon: "dot.viewfinder")
                }

                // Close button
                Button {
                    selectedGarage = nil
                } label: {
                    CommonIconButtonView(icon: "xmark")
                }
                .padding(.horizontal, UIScreen.main.bounds.width * 0.05)
            }

            NormalTextView(
                text: garage.address,
                multilineTextAlignment: .leading
            )

            // Show directions button
            Button {
                getDirection(
                    destination: CLLocationCoordinate2D(
                        latitude: garage.latitude,
                        longitude: garage.longitude
                    )
                )
                isShowingNavigationSheet = true
            } label: {
                CommonButtonView(
                    buttonText: "Show Me Direction",
                    backgroundColor: Color("inputBackground"),
                    foregroundColor: Color("brandColor")
                )
            }
            .padding(.horizontal, UIScreen.main.bounds.width * 0.05)

            // Garage images
            if let imageUrls = garage.imageUrls {
                ScrollView {
                    LazyVGrid(columns: gridItems) {
                        ForEach(imageUrls, id: \.self) { url in
                            CommonSquareImageView(url: url)
                        }
                    }
                    .padding(.horizontal, UIScreen.main.bounds.width * 0.05)
                }
            }

            Spacer()
        }
        .presentationDetents([.medium, .large])
        .ignoresSafeArea()
        .frame(maxWidth: .infinity)
        .padding(.top, 16)
        .background(Color("commonBackground"))
    }

    // Calculates route from current location to garage
    func getDirection(destination: CLLocationCoordinate2D) {
        Task {
            guard var userLocation = await getUserLocation() else { return }

            // Temporary fallback location
            userLocation = CLLocationCoordinate2D(
                latitude: 37.3349,
                longitude: -122.0090
            )

            let request = MKDirections.Request()
            request.source = MKMapItem(
                placemark: .init(coordinate: userLocation)
            )
            request.destination = MKMapItem(
                placemark: .init(coordinate: destination)
            )
            request.transportType = .automobile

            do {
                let directions = try await MKDirections(request: request)
                    .calculate()
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

    // Gets user location asynchronously using live updates
    func getUserLocation() async -> CLLocationCoordinate2D? {
        let updates = CLLocationUpdate.liveUpdates()
        do {
            let update = try await updates.first {
                $0.location?.coordinate != nil
            }
            return update?.location?.coordinate
        } catch {
            print("cannot get user location")
            return nil
        }
    }

    // Fetches Look Around scene based on garage coordinate
    func getLookAroundScene(coordinate: CLLocationCoordinate2D) async
        -> MKLookAroundScene?
    {
        do {
            return try await MKLookAroundSceneRequest(coordinate: coordinate)
                .scene
        } catch {
            print("Cannot get look around scene")
            return nil
        }
    }
}

// SwiftUI Preview
#Preview {
    MapView()
        .environmentObject(GlobalDto.shared)
}

