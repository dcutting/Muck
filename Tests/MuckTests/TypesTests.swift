import Testing
@testable import MuckCore
@testable import MuckSourceKit
@testable import MuckCLI

struct TypesTests {

    var sut = Types()

    @Test
    mutating func test_numberAbstracts() {
        sut.addAbstract(any())
        sut.addAbstract(any())
        sut.addAbstract(any())
        #expect((3) == (sut.numberAbstracts))
    }

    @Test
    mutating func test_numberTypes() {
        sut.addAbstract(any())
        sut.addAbstract(any())
        sut.addConcrete(any())
        sut.addConcrete(any())
        #expect((4) == (sut.numberTypes))
    }

    @Test
    mutating func test_abstractness() {
        sut.addAbstract(any())
        sut.addAbstract(any())
        sut.addConcrete(any())
        let actual = sut.abstractness
        #expect(abs((0.6666) - (actual)) < 0.001)
    }

    @Test
    mutating func test_abstractness_zeroDeclarations() {
        let actual = sut.abstractness
        #expect(abs((1.0) - (actual)) < 0.001)
    }
}
