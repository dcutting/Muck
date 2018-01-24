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
        let input: [Float] = [3.4, 5.3, 9.9]
        let actual: Float = input.mean!
        XCTAssertEqual(6.2, actual, accuracy: 0.001)
    }

    func test_mean_doubleCollection() {
        let input: [Double] = [3.4, 5.3, 9.9]
        let actual: Double = input.mean!
        XCTAssertEqual(6.2, actual, accuracy: 0.001)
    }

    func test_mean_intCollection() {
        let actual = [3, 4, 6].mean!
        XCTAssertEqual(4.333, actual, accuracy: 0.001)
    }

    func test_median_empty_returnsNil() {
        let input = [Int]()
        XCTAssertNil(input.median)
    }

    func test_median_oddCount_returnsMiddleElement() {
        let input = [4, 5, 3]
        XCTAssertEqual(4, input.median)
    }

    func test_median_evenCount_returnsMeanOfMiddleElements() {
        let actual = [4, 5, 3, 9].median!
        XCTAssertEqual(4.5, actual, accuracy: 0.001)
    }

    func test_standardDeviation_empty_returnsNil() {
        let input = [Float]()
        XCTAssertNil(input.standardDeviation)
    }

    func test_standardDeviation() {
        let input: [Float] = [3.4, 5.3, 9.9]
        let actual = input.standardDeviation!
        XCTAssertEqual(2.7288581250528, actual, accuracy: 0.00001)
    }

    func test_isEven_oddInput_returnsFalse() {
        XCTAssertFalse(5.isEven)
    }

    func test_isEven_evenInput_returnsTrue() {
        XCTAssertTrue(6.isEven)
    }
}
