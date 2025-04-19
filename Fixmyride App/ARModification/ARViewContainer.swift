import SwiftUI
import RealityKit

struct ARViewContainer: UIViewRepresentable {
    let viewModel: ARCarViewModel
    func makeUIView(context: Context) -> ARView {
        viewModel.setupScene()
        return viewModel.arView
    }
    func updateUIView(_ uiView: ARView, context: Context) { }
}

