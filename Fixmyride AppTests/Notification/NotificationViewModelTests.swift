import XCTest
@testable import Fixmyride_App

final class NotificationViewModelTests: XCTestCase {
    var viewModel: NotificationViewModel!

    override func setUp() {
        viewModel = NotificationViewModel.shared
    }

    func testInitialNotificationsIsEmpty() {
        XCTAssertTrue(viewModel.notifications.isEmpty)
    }
}

