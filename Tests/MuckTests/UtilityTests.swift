import XCTest
@testable import Muck

class UtilityTests: XCTestCase {

    func test_isEven_oddInput_returnsFalse() {
        XCTAssertFalse(5.isEven)
    }

    func test_isEven_evenInput_returnsTrue() {
        XCTAssertTrue(6.isEven)
    }
}
