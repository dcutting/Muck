import XCTest
@testable import Muck

class ReporterTests: XCTestCase {

    let sut: Reporter = any()

    func test_calculateRating_A() {
        let actual = sut.calculateRating(distance: 0.05)
        XCTAssertEqual("A", actual)
    }

    func test_calculateRating_B() {
        let actual = sut.calculateRating(distance: 0.15)
        XCTAssertEqual("B", actual)
    }

    func test_calculateRating_C() {
        let actual = sut.calculateRating(distance: 0.35)
        XCTAssertEqual("C", actual)
    }

    func test_calculateRating_D() {
        let actual = sut.calculateRating(distance: 0.55)
        XCTAssertEqual("D", actual)
    }
}
