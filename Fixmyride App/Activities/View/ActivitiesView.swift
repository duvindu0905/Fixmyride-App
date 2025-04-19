import SwiftUI

struct ActivitiesView: View {
    @StateObject private var viewModel = ActivitiesViewModel.shared

    var body: some View {
        ZStack {
            CommonBackgroundView()

            VStack(alignment: .leading, spacing: 16) {
                TitleTextView(text: "My Activities")
                    .padding(.horizontal)

                HStack {
                    Text("Pending").foregroundColor(.gray)
                    Spacer()
                    Text("Upcoming").foregroundColor(.gray)
                    Spacer()
                    Text("Completed")
                        .bold()
                        .underline()
                }
                .padding(.horizontal)
                .padding(.top, 8)

                if !viewModel.activities.isEmpty {
                    if #available(iOS 17.0, *) {
                        List {
                            ForEach(viewModel.activities) { activity in
                                VStack(alignment: .leading, spacing: 4) {
                                    HStack {
                                        Text("Booking ID: \(activity.bookingId)")
                                            .foregroundColor(.blue)
                                            .fontWeight(.semibold)
                                        Spacer()
                                        Text(activity.date)
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }

                                    Text(activity.centerName)
                                        .fontWeight(.semibold)
                                    Spacer()
                                    Text(activity.description)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.black)

                                    HStack {
                                        Spacer()
                                        Text(String(format: "Rs. %.2f", activity.price))
                                            .fontWeight(.semibold)
                                    }
                                }
                                .padding(.vertical, 8)
                            }
                        }
                        .contentMargins(.vertical, 10)
                    } else {
                        Text("List for iOS <17.0 not implemented.")
                    }
                } else {
                    FootnoteTextView(text: "No activities found")
                }

                Spacer()
            }
            .padding(.top, 32)
        }
        .onAppear {
            viewModel.getCompletedActivities { fetched in
                viewModel.activities = fetched
            }
        }
    }
}

#Preview {
    ActivitiesView()
}


