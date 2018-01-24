import XCTest
@testable import Muck

class ReferencesTests: XCTestCase {

    var sut: References!

    override func setUp() {
        sut = References()
    }

    func test_fanIn() {
        sut.addDependency(on: any(), from: dummy())
        sut.addDependency(on: any(), from: dummy())
        sut.addDependency(on: any(), from: dummy())
        XCTAssertEqual(3, sut.fanIn)
    }

    func test_fanOut() {
        sut.addDependency(on: dummy(), ownedBy: any())
        sut.addDependency(on: dummy(), ownedBy: any())
        XCTAssertEqual(2, sut.fanOut)
    }

    func test_instability() {
        sut.addDependency(on: any(), from: dummy())
        sut.addDependency(on: any(), from: dummy())
        sut.addDependency(on: dummy(), ownedBy: any())
        XCTAssertEqual(0.3333, sut.instability, accuracy: 0.001)
    }

    func test_addDependency_sameDependencyIsOnlyAddedOnce() {
        let entity: Entity = dummy()
        let owner: ComponentID = dummy()
        sut.addDependency(on: entity, ownedBy: owner)
        sut.addDependency(on: entity, ownedBy: owner)
        XCTAssertEqual(1, sut.fanOut)
    }

    func test_addDependent_sameDependencyIsOnlyAddedOnce() {
        let entity: Entity = dummy()
        let owner: ComponentID = dummy()
        sut.addDependency(on: entity, from: owner)
        sut.addDependency(on: entity, from: owner)
        XCTAssertEqual(1, sut.fanIn)
    }
}
