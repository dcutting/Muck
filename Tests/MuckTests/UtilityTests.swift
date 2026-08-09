import Testing
@testable import Muck

struct UtilityTests {

    @Test
    func test_sum_emptySequence_returns0() {
        let input = [Int]()
        #expect((0) == (input.sum))
    }

    @Test
    func test_sum() {
        #expect([1, -2, 4].sum == 3)
    }

    @Test
    func test_mean_emptyFloatCollection_returnsNil() {
        let input = [Float]()
        #expect((input.mean) == nil)
    }

    @Test
    func test_mean_emptyIntCollection_returnsNil() {
        let input = [Int]()
        #expect((input.mean) == nil)
    }

    @Test
    func test_mean_floatCollection() {
        let input: [Float] = [3.4, 5.3, 9.9]
        let actual: Float = input.mean!
        #expect(abs((6.2) - (actual)) < 0.001)
    }

    @Test
    func test_mean_doubleCollection() {
        let input: [Double] = [3.4, 5.3, 9.9]
        let actual: Double = input.mean!
        #expect(abs((6.2) - (actual)) < 0.001)
    }

    @Test
    func test_mean_intCollection() {
        let actual = [3, 4, 6].mean!
        #expect(abs((4.333) - (actual)) < 0.001)
    }

    @Test
    func test_median_empty_returnsNil() {
        let input = [Int]()
        #expect((input.median) == nil)
    }

    @Test
    func test_median_oddCount_returnsMiddleElement() {
        let input = [4, 5, 3]
        #expect((4) == (input.median))
    }

    @Test
    func test_median_evenCount_returnsMeanOfMiddleElements() {
        let actual = [4, 5, 3, 9].median!
        #expect(abs((4.5) - (actual)) < 0.001)
    }

    @Test
    func test_standardDeviation_empty_returnsNil() {
        let input = [Float]()
        #expect((input.standardDeviation) == nil)
    }

    @Test
    func test_standardDeviation() {
        let input: [Float] = [3.4, 5.3, 9.9]
        let actual = input.standardDeviation!
        #expect(abs((2.7288581250528) - (actual)) < 0.00001)
    }

    @Test
    func test_isEven_oddInput_returnsFalse() {
        #expect(!5.isEven)
    }

    @Test
    func test_isEven_evenInput_returnsTrue() {
        #expect(6.isEven)
    }
}
