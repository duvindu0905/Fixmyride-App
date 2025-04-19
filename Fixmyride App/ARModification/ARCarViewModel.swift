import RealityKit
import ARKit
import SwiftUI
import simd

@MainActor
final class ARCarViewModel: ObservableObject {

    // MARK: – Public state
    @Published var selectedWheel = "classic_wheel_r15"
    let wheelOptions            = ["classic_wheel_r15", "free_wheel", "wheel"]

    // MARK: – Internals
    let  arView = ARView(frame: .zero)
    private var wheelEntities: [Entity] = []          // keeps current wheels

    // MARK: – Scene setup ---------------------------------------------------
    func setupScene() {
        let cfg = ARWorldTrackingConfiguration()
        cfg.planeDetection = [.horizontal]
        arView.session.run(cfg)

        // Comment out these two lines for production
        arView.debugOptions = [.showAnchorOrigins, .showFeaturePoints]

        Task { await placeCar() }
    }

    // MARK: – Place & prepare car ------------------------------------------
    private func placeCar() async {
        do {
            var car = try await Entity.load(named: "red_car")
            car.scaleAndGround(to: 1.0)

            // cache *only* the visible mesh‑bearing nodes
            wheelEntities = car.collect { $0.name.lowercased().contains("wheel") }
                              .compactMap(\.firstModel)

            let anchor = AnchorEntity(
                plane: .horizontal,
                classification: .any,
                minimumBounds: SIMD2<Float>(0.1, 0.1)
            )
            anchor.addChild(car)
            arView.scene.anchors.append(anchor)

            await replaceWheels()                        // default set
        }
        catch { print("❌ Could not load / place car:", error) }
    }

    // MARK: – Wheel swapping -----------------------------------------------
    func replaceWheels() async {
        guard !wheelEntities.isEmpty else { return }

        do {
            // Load replacement prototype
            let protoRoot = try await Entity.load(named: selectedWheel)
            guard let protoMesh = protoRoot.firstModel else {
                print("⚠️  \(selectedWheel) contains no geometry"); return
            }

            var fresh: [Entity] = []

            for oldMesh in wheelEntities {
                guard let parent = oldMesh.parent else { continue }

                // Duplicate prototype and copy transform so it snaps in place
                let newWheel       = protoMesh.clone(recursive: true)
                newWheel.name      = oldMesh.name
                newWheel.transform = oldMesh.transform

                oldMesh.removeFromParent()
                parent.addChild(newWheel)
                fresh.append(newWheel)
            }

            wheelEntities = fresh                         // 🔑 update cache
        }
        catch { print("❌ Wheel swap failed:", error) }
    }
}

