import XCTest
@testable import Muck

class UtilityTests: XCTestCase {

    func test_sum_emptySequence_returns0() {
        let input = [Int]()
        XCTAssertEqual(input.sum, 0)
    }

    func test_sum() {
        XCTAssertEqual([1,-2,4].sum, 3)
    }

    func test_isEven_oddInput_returnsFalse() {
        XCTAssertFalse(5.isEven)
    }

    func test_isEven_evenInput_returnsTrue() {
        XCTAssertTrue(6.isEven)
    }
}
