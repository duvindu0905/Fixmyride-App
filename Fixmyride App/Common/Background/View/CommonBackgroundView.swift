import SwiftUI

struct CommonBackgroundView: View {
    var body: some View {
        ContainerRelativeShape()
            .fill(Color("commonBackground"))
            .ignoresSafeArea(.all)
    }
}

#Preview {
    CommonBackgroundView()
}
