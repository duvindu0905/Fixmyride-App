import SwiftUI

struct ARCarModificationView: View {
    @StateObject private var vm = ARCarViewModel()

    var body: some View {
        ZStack {
            ARViewContainer(viewModel: vm)
                .edgesIgnoringSafeArea(.all)

            // Wheel picker – bottom overlay
            VStack {
                Spacer()
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 18) {
                        ForEach(vm.wheelOptions, id: \.self) { wheel in
                            WheelButton(label: wheel,
                                        isSelected: vm.selectedWheel == wheel) {
                                vm.selectedWheel = wheel
                                Task { await vm.replaceWheels() }
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                }
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                .padding(.bottom, 12)
            }
        }
        .navigationTitle("Back")
    }
}

private struct WheelButton: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Circle()
                    .fill(isSelected ? Color.blue : .white)
                    .frame(width: 52, height: 52)
                Text(label)
                    .font(.caption2)
                    .foregroundColor(.primary)
            }
            .padding(8)
        }
    }
}

#Preview { ARCarModificationView() }

