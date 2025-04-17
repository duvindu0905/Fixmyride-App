import SwiftUI
import MapKit

struct MapView: View {
    @EnvironmentObject var globalDto: GlobalDto
    let locationManager = CLLocationManager()
    
    @State private var lookAroundScene: MKLookAroundScene?
    @State private var isShowingLookAroundScene = false
    @State private var garages: [GarageModel] = []
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
        let allGarages = MapViewModel.shared.getLatestSearches()
        if searchTerm.isEmpty {
            return allGarages
        } else {
            return allGarages.filter {
                $0.name.localizedCaseInsensitiveContains(searchTerm) }
        }
    }
    
    var body: some View {
        
        Map {
            ForEach(garages) { garage in
                Annotation(garage.name, coordinate: CLLocationCoordinate2D(latitude: garage.latitude, longitude: garage.longitude), anchor: .bottom) {
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
            isSearchBarFocused = false
            locationManager.requestWhenInUseAuthorization()
            let myMap = MapViewModel.shared.getRelevantMap()
            garages = myMap.garages
            
            if globalDto.comingFrom == Route.garage.rawValue {
                isShowingHomeSheet = false
                globalDto.comingFrom = ""
            } else {
                isShowingHomeSheet = true
            }
        }
        .sheet(isPresented: $isShowingHomeSheet) {
            if isSearchBarFocused {
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
                            ForEach(0..<filteredSearches.count, id: \.self) { index in
                                let garage = filteredSearches[index]
                                Button {
                                    isShowingHomeSheet = false
                                    selectedGarage = garage
                                } label: {
                                    // Use garage.type to change icon if needed
                                    if garage.type == .repairCenter {
                                        CommonNavigationListType2View(
                                            icon: "wrench.fill",
                                            titleText: garage.name,
                                            tagText: garage.address,
                                            tagText2: "",
                                            size: 0.06
                                        )
                                    } else if garage.type == .engineering {
                                        CommonNavigationListType2View(
                                            icon: "gearshape.fill",
                                            titleText: garage.name,
                                            tagText: garage.address,
                                            tagText2: "",
                                            size: 0.06
                                        )
                                    } else if garage.type == .detailing {
                                        CommonNavigationListType2View(
                                            icon: "sparkles",
                                            titleText: garage.name,
                                            tagText: garage.address,
                                            tagText2: "",
                                            size: 0.06
                                        )
                                    } else if garage.type == .painting {
                                        CommonNavigationListType2View(
                                            icon: "paintbrush.fill",
                                            titleText: garage.name,
                                            tagText: garage.address,
                                            tagText2: "",
                                            size: 0.06
                                        )
                                    } else {
                                        // fallback
                                        CommonNavigationListType2View(
                                            icon: "wrench.fill",
                                            titleText: garage.name,
                                            tagText: garage.address,
                                            tagText2: "",
                                            size: 0.06
                                        )
                                    }
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
                .frame(maxWidth: .infinity)
                .padding(.top, 16)
                .background(.white)
            } else {
                VStack {
                    VStack(spacing: 16) {
                        CommonSearchBarView(
                            isFocused: $isSearchBarFocused,
                            searchTerm: $searchTerm,
                            hint: "Search garages"
                        )
                        
                        HStack {
                            NormalTextView(
                                text: "Latest searches",
                                multilineTextAlignment: .leading
                            )
                            Spacer()
                        }
                        
                        ScrollView {
                            LazyVGrid(columns: gridItems) {
                                ForEach(0..<filteredSearches.count, id: \.self) { index in
                                    let garage = filteredSearches[index]
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
                        
                    }
                    .padding(.horizontal, UIScreen.main.bounds.width * 0.05)
                    
                    Spacer()
                }
                .presentationDetents([.medium, .large])
                .ignoresSafeArea()
                .frame(maxWidth: .infinity)
                .padding(.top, 16)
                .background(Color("commonBackground"))
            }
        }
        
        
        .sheet(isPresented: $isShowingNavigationSheet) {
            VStack {
                VStack(spacing: 0) {
                    HStack {
                        SecondaryHeadingTextView(text: "Directions")
                        Spacer()
                        Button {
                            isShowingNavigationSheet = false
                        } label: {
                            CommonIconButtonView(icon: "xmark")
                        }
                    }
                }
                .padding(.horizontal, UIScreen.main.bounds.width * 0.05)
                
                // Summary info (distance & time)
                List {
                    CommonStaticListView(
                        icon: "app.connected.to.app.below.fill",
                        titleText: "(\(Int(distance ?? 0)) m)",
                        valueText: "\(estimatedTime ?? 0) min"
                    )
                }
                .contentMargins(.vertical, 8)
                .frame(maxHeight: 100)
                
                // Step-by-step directions
                List {
                    if let steps = steps, !steps.isEmpty {
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
            .frame(maxWidth: .infinity)
            .padding(.top, 16)
            .background(Color("commonBackground"))
        }
        
        .sheet(item: $selectedGarage) { garage in
            VStack(spacing: 16) {
                HStack {
                    SecondaryHeadingTextView(text: garage.name)
                    Spacer()
                    Button {
                        Task {
                            lookAroundScene = await getLookAroundScene(
                                coordinate: CLLocationCoordinate2D(latitude: garage.latitude, longitude: garage.longitude)
                            )
                            isShowingLookAroundScene = (lookAroundScene != nil)
                        }
                    } label: {
                        CommonIconButtonView(icon: "dot.viewfinder")
                    }
                    
                    Button {
                        selectedGarage = nil
                    } label: {
                        CommonIconButtonView(icon: "xmark")
                    }
                }
                
                NormalTextView(text: garage.address, multilineTextAlignment: .leading)
                
                Button {
                    getDirection(destination: CLLocationCoordinate2D(latitude: garage.latitude, longitude: garage.longitude))
                    isShowingNavigationSheet = true
                } label: {
                    CommonButtonView(
                        buttonText: "Show Me Direction",
                        backgroundColor: Color("inputBackground"),
                        foregroundColor: Color("brandColor")
                    )
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
    }
    
    func getDirection(destination: CLLocationCoordinate2D) {
        Task {
            guard let userLocation = await getUserLocation() else {
                return
            }

            let request = MKDirections.Request()
            request.source = MKMapItem(
                placemark: .init(coordinate: userLocation)
            )
            request.destination = MKMapItem(
                placemark: .init(coordinate: destination)
            )
            request.transportType = .walking

            do {
                let directions = try await MKDirections(request: request)
                    .calculate()

                if let route = directions.routes.first {
                    self.route = route
                    let distance = route.distance
                    let estimatedTime = Int(route.expectedTravelTime / 60)
                    self.distance = distance
                    self.estimatedTime = estimatedTime
                    print("dis: \(distance)")
                    print("time: \(estimatedTime)")
                    self.steps = route.steps
                    for (index, step) in route.steps.enumerated() {
                        print("Step \(index + 1): \(step.instructions)")
                    }
                    let startName =
                        request.source?.name ?? "Unknown Start Location"
                    let endName =
                        request.destination?.name ?? "Unknown Destination"
                    print("start: \(startName)")
                    print("end: \(endName)")
                }

            } catch {
                print("cannot get route \(error)")
            }
        }
    }

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

    func getLookAroundScene(coordinate: CLLocationCoordinate2D) async
        -> MKLookAroundScene?
    {
        do {
            return try await MKLookAroundSceneRequest(
                coordinate: coordinate
            ).scene
        } catch {
            print("Cannot get look around scene")
            return nil
        }
    }

}

#Preview {
    MapView().environmentObject(GlobalDto.shared)
}

