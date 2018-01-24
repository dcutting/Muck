import XCTest
@testable import Muck

class DoubleConvertibleTests: XCTestCase {

    func test_doubleAsDouble() {
        let x: Double = 5.3
        let actual: Double = x.asDouble()
        let expected: Double = 5.3
        XCTAssertEqual(expected, actual, accuracy: 0.001)
    }

    func test_intAsDouble() {
        let x: Int = 5
        let actual: Double = x.asDouble()
        let expected: Double = 5.0
        XCTAssertEqual(expected, actual, accuracy: 0.001)
    }

    func test_floatAsDouble() {
        let x: Float = 5.3
        let actual: Double = x.asDouble()
        let expected: Double = 5.3
        XCTAssertEqual(expected, actual, accuracy: 0.001)
    }
}
