import XCTest
@testable import Fixmyride_App

final class LoginViewModelTests: XCTestCase {
    var viewModel: LoginViewModel!

    override func setUp() {
        viewModel = LoginViewModel()
    }

    func testValidEmail() {
        viewModel.email = "user@example.com"
        XCTAssertTrue(viewModel.login())
    }

    func testInvalidEmail() {
        viewModel.email = "invalid"
        XCTAssertFalse(viewModel.login())
    }
}

