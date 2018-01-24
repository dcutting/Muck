import XCTest
@testable import Muck

class UtilityTests: XCTestCase {

    func test_sum_emptySequence_returns0() {
        let input = [Int]()
        XCTAssertEqual(0, input.sum)
    }

    func test_sum() {
        XCTAssertEqual(3, [1, -2, 4].sum)
    }

    func test_mean_emptyFloatCollection_returnsNil() {
        let input = [Float]()
        XCTAssertNil(input.mean)
    }

    func test_mean_emptyIntCollection_returnsNil() {
        let input = [Int]()
        XCTAssertNil(input.mean)
    }

    func test_mean_floatCollection() {
        let actual = [3.4, 5.3, 9.9].mean!
        XCTAssertEqual(6.2, actual, accuracy: 0.001)
    }

    func test_mean_intCollection() {
        let actual = [3, 4, 6].mean!
        XCTAssertEqual(4.333, actual, accuracy: 0.001)
    }

    func test_isEven_oddInput_returnsFalse() {
        XCTAssertFalse(5.isEven)
    }

    func test_isEven_evenInput_returnsTrue() {
        XCTAssertTrue(6.isEven)
    }
}
