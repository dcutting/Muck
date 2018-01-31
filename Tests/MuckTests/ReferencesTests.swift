import XCTest
@testable import Muck

class ReferencesTests: XCTestCase {

    var sut: References!

    override func setUp() {
        sut = References()
    }

    func test_fanIn() {
        sut.addDependent(componentID: dummy(), declarationID: dummy())
        sut.addDependent(componentID: dummy(), declarationID: dummy())
        sut.addDependent(componentID: dummy(), declarationID: dummy())
        XCTAssertEqual(3, sut.fanIn)
    }

    func test_fanOut() {
        sut.addDependency(componentID: dummy(), declarationID: dummy())
        sut.addDependency(componentID: dummy(), declarationID: dummy())
        XCTAssertEqual(2, sut.fanOut)
    }

    func test_instability() {
        sut.addDependent(componentID: dummy(), declarationID: dummy())
        sut.addDependent(componentID: dummy(), declarationID: dummy())
        sut.addDependency(componentID: dummy(), declarationID: dummy())
        XCTAssertEqual(0.3333, sut.instability, accuracy: 0.001)
    }

    func test_instability_zeroFanInOut() {
        XCTAssertEqual(0.0, sut.instability, accuracy: 0.001)
    }

    func test_addDependency_sameDependencyIsOnlyAddedOnce() {
        let declarationID: DeclarationID = dummy()
        let componentID: ComponentID = dummy()
        sut.addDependency(componentID: componentID, declarationID: declarationID)
        sut.addDependency(componentID: componentID, declarationID: declarationID)
        XCTAssertEqual(1, sut.fanOut)
    }

    func test_addDependent_sameDependencyIsOnlyAddedOnce() {
        let declarationID: DeclarationID = dummy()
        let componentID: ComponentID = dummy()
        sut.addDependent(componentID: componentID, declarationID: declarationID)
        sut.addDependent(componentID: componentID, declarationID: declarationID)
        XCTAssertEqual(1, sut.fanIn)
    }
}
