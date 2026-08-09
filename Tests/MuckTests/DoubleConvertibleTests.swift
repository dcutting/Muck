import Testing
@testable import Muck

struct DoubleConvertibleTests {

    @Test
    func test_doubleAsDouble() {
        let x: Double = 5.3
        let actual: Double = x.asDouble()
        let expected: Double = 5.3
        #expect(abs((expected) - (actual)) < 0.001)
    }

    @Test
    func test_intAsDouble() {
        let x: Int = 5
        let actual: Double = x.asDouble()
        let expected: Double = 5.0
        #expect(abs((expected) - (actual)) < 0.001)
    }

    @Test
    func test_floatAsDouble() {
        let x: Float = 5.3
        let actual: Double = x.asDouble()
        let expected: Double = 5.3
        #expect(abs((expected) - (actual)) < 0.001)
    }
}
