import RealityKit
import simd

extension Entity {

    // Fits the entity inside `target` m and grounds it (bottom touches y = 0)
    func scaleAndGround(to target: Float) {
        let bounds  = visualBounds(relativeTo: nil)
        let maxDim  = max(bounds.extents.x, bounds.extents.y, bounds.extents.z)
        let factor  = target / maxDim
        scale      *= SIMD3(repeating: factor)
        position.y -= bounds.min.y * factor
    }

    // Recursively collect nodes satisfying the predicate
    func collect(where predicate: (Entity) -> Bool) -> [Entity] {
        var out: [Entity] = predicate(self) ? [self] : []
        for child in children { out += child.collect(where: predicate) }
        return out
    }

    // First ModelEntity (the thing with actual geometry) in the subtree
    var firstModel: ModelEntity? {
        if let me = self as? ModelEntity { return me }
        for child in children {
            if let found = child.firstModel { return found }
        }
        return nil
    }
}

