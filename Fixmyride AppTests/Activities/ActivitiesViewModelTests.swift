import XCTest
@testable import Fixmyride_App

final class ActivitiesViewModelTests: XCTestCase {
    var viewModel: ActivitiesViewModel!

    override func setUp() {
        viewModel = ActivitiesViewModel.shared
    }

    func testInitialActivitiesIsEmpty() {
        XCTAssertTrue(viewModel.activities.isEmpty)
    }
}

