import SwiftUI

struct ActivitiesView: View {
    @StateObject private var viewModel = ActivitiesViewModel.shared
    @State private var selectedTab: ActivityTab = .completed

    enum ActivityTab {
        case upcoming, completed
    }

    var body: some View {
        ZStack {
            CommonBackgroundView()

            VStack(alignment: .leading, spacing: 16) {
                TitleTextView(text: "My Activities")
                    .padding(.horizontal)

              
                HStack {
                    Button(action: {
                        selectedTab = .upcoming
                        viewModel.getUpcomingActivities { fetched in
                            viewModel.activities = fetched
                        }
                    }) {
                        Text("Upcoming")
                            .foregroundColor(selectedTab == .upcoming ? .blue : .gray)
                            .bold(selectedTab == .upcoming)
                    }

                    Spacer()

                    Button(action: {
                        selectedTab = .completed
                        viewModel.getCompletedActivities { fetched in
                            viewModel.activities = fetched
                        }
                    }) {
                        Text("Completed")
                            .foregroundColor(selectedTab == .completed ? .blue : .gray)
                            .bold(selectedTab == .completed)
                    }
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
                                            .fontWeight(.semibold)
                                    }

                                    Text(activity.centerName)
                                        .fontWeight(.semibold)

                                    Text(activity.description)
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
                    FootnoteTextView(text: "No \(selectedTab == .upcoming ? "upcoming" : "completed") activities found")
                        .padding(.horizontal)
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

