import SwiftUI

class BiometricSettings {
    static let shared = BiometricSettings()

    private let useFaceIDKey = "useFaceID"

    func isFaceIDEnabled() -> Bool {
        return UserDefaults.standard.bool(forKey: useFaceIDKey)
    }

    func setFaceIDEnabled(_ enabled: Bool) {
        UserDefaults.standard.set(enabled, forKey: useFaceIDKey)
    }
}

