import XCTest
@testable import Muck

class DeclarationsTests: XCTestCase {

    var sut: Declarations!

    override func setUp() {
        sut = Declarations()
    }

    func test_numberAbstracts() {
        sut.addAbstract(any())
        sut.addAbstract(any())
        sut.addAbstract(any())
        XCTAssertEqual(3, sut.numberAbstracts)
    }

    func test_numberDeclarations() {
        sut.addAbstract(any())
        sut.addAbstract(any())
        sut.addConcrete(any())
        sut.addConcrete(any())
        XCTAssertEqual(4, sut.numberDeclarations)
    }

    func test_abstractness_noDeclarations_throws() {
        // sut.abstractness will fail precondition
    }

    func test_abstractness() {
        sut.addAbstract(any())
        sut.addAbstract(any())
        sut.addConcrete(any())
        let actual = sut.abstractness
        XCTAssertEqual(0.6666, actual, accuracy: 0.001)
    }
}
