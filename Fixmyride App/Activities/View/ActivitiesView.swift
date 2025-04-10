import SwiftUI

struct ActivitiesView: View {
    @State private var activities: [ActivitiesModel] = ActivitiesViewModel.shared.getAllActivities()

    var body: some View {
        ZStack {
            CommonBackgroundView()

            VStack(spacing: 16) {
                HStack {
                    TitleTextView(text: "Activities")
                    Spacer()
                }
                .padding(.top, 32)
                .padding(.horizontal, UIScreen.main.bounds.width * 0.05)

                Button {
                    // Action for date filter goes here
                } label: {
                    CommonButtonView(
                        buttonText: "13 Feb 25 - 23 Feb 25",
                        backgroundColor: Color("inputBackground"),
                        foregroundColor: .black
                    )
                }
                .padding(.horizontal, UIScreen.main.bounds.width * 0.05)

                List {
                    ForEach(activities, id: \.bookingID) { activity in
                        CommonNavigationListType3(
                            titleText: activity.centerName,
                            subtitleText: activity.serviceDescription,
                            taglineText: "\(activity.date), \(activity.time) • \(activity.price)"
                        )
                    }
                }
                .listStyle(.plain)
                .padding(.top, 16)

                Spacer()
            }
        }
    }
}

#Preview {
    ActivitiesView()
}

