import RealityKit
import ARKit
import SwiftUI
import simd

@MainActor
final class ARCarViewModel: ObservableObject {

    // Public ---------------------------------------------------------------
    @Published var selectedWheel = "classic_wheel_r15"
    let wheelOptions            = ["classic_wheel_r15", "free_wheel", "wheel"]

    // Internals ------------------------------------------------------------
    let  arView = ARView(frame: .zero)
    private var wheelEntities: [Entity] = []

    // MARK: Scene setup ----------------------------------------------------
    func setupScene() {
        let cfg = ARWorldTrackingConfiguration()
        cfg.planeDetection = [.horizontal]
        arView.session.run(cfg)

        arView.debugOptions = [.showAnchorOrigins, .showFeaturePoints]
        Task { await placeCar() }
    }

    // MARK: Place car -------------------------------------------------------
    private func placeCar() async {
        do {
            var car = try await Entity.load(named: "red_car")
            car.scaleAndGround(to: 1.0)

            wheelEntities = car.collect { $0.name.lowercased().contains("wheel") }

            let anchor = AnchorEntity(
                plane: .horizontal,
                classification: .any,
                minimumBounds: SIMD2<Float>(0.1, 0.1)
            )
            anchor.addChild(car)
            arView.scene.anchors.append(anchor)

            await replaceWheels()
        }
        catch { print("❌ Could not load / place car:", error) }
    }

    // MARK: Swap wheels -----------------------------------------------------
    func replaceWheels() async {
        do {
            let prototype = try await Entity.load(named: selectedWheel)

            var fresh: [Entity] = []                         // ⬅️ track new wheels

            for old in wheelEntities {
                guard let parent = old.parent else { continue }

                // 1. Clone & copy transform so it snaps into identical spot
                let newWheel       = prototype.clone(recursive: true)
                newWheel.name      = old.name
                newWheel.transform = old.transform            // keep position / rot / scale

                // 2. Replace in scene graph
                old.removeFromParent()
                parent.addChild(newWheel)

                fresh.append(newWheel)                       // cache for next swap
            }

            wheelEntities = fresh                            // ✅ now up‑to‑date
        }
        catch { print("❌ Wheel swap failed:", error) }
    }
}

