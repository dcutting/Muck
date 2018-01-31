import XCTest
@testable import Muck

class TypesTests: XCTestCase {

    var sut: Types!

    override func setUp() {
        sut = Types()
    }

    func test_numberAbstracts() {
        sut.addAbstract(any())
        sut.addAbstract(any())
        sut.addAbstract(any())
        XCTAssertEqual(3, sut.numberAbstracts)
    }

    func test_numberTypes() {
        sut.addAbstract(any())
        sut.addAbstract(any())
        sut.addConcrete(any())
        sut.addConcrete(any())
        XCTAssertEqual(4, sut.numberTypes)
    }

    func test_abstractness() {
        sut.addAbstract(any())
        sut.addAbstract(any())
        sut.addConcrete(any())
        let actual = sut.abstractness
        XCTAssertEqual(0.6666, actual, accuracy: 0.001)
    }

    func test_abstractness_zeroDeclarations() {
        let actual = sut.abstractness
        XCTAssertEqual(1.0, actual, accuracy: 0.001)
    }
}
