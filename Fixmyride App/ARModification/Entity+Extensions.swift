import RealityKit
import simd

extension Entity {

    /// Scales the entity so its largest dimension ≤ `target` metres
    /// and moves it down so its lowest point touches y = 0.
    func scaleAndGround(to target: Float) {
        // 1️⃣ Work out the current bounds
        let bounds = visualBounds(relativeTo: nil)
        let maxDim = max(bounds.extents.x, bounds.extents.y, bounds.extents.z)

        // 2️⃣ Scale so the largest dimension == target
        let factor = target / maxDim
        scale *= SIMD3(repeating: factor)

        // 3️⃣ Shift down so the lowest vertex sits on the detected plane
        position.y -= bounds.min.y * factor
    }

    /// Recursively collects descendants satisfying `predicate`.
    func collect(where predicate: (Entity) -> Bool) -> [Entity] {
        var result: [Entity] = predicate(self) ? [self] : []
        for child in children {
            result += child.collect(where: predicate)
        }
        return result
    }
}

