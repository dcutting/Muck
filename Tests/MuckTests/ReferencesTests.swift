import Testing
@testable import MuckCore
@testable import MuckSourceKit
@testable import MuckCLI

struct ReferencesTests {

    var sut = References()

    @Test
    mutating func test_fanIn() {
        sut.addDependent(componentID: dummy(), declarationID: dummy())
        sut.addDependent(componentID: dummy(), declarationID: dummy())
        sut.addDependent(componentID: dummy(), declarationID: dummy())
        #expect((3) == (sut.fanIn))
    }

    @Test
    mutating func test_fanOut() {
        sut.addDependency(componentID: dummy(), declarationID: dummy())
        sut.addDependency(componentID: dummy(), declarationID: dummy())
        #expect((2) == (sut.fanOut))
    }

    @Test
    mutating func test_instability() {
        sut.addDependent(componentID: dummy(), declarationID: dummy())
        sut.addDependent(componentID: dummy(), declarationID: dummy())
        sut.addDependency(componentID: dummy(), declarationID: dummy())
        #expect(abs((0.3333) - (sut.instability)) < 0.001)
    }

    @Test
    mutating func test_instability_zeroFanInOut() {
        #expect(abs((0.0) - (sut.instability)) < 0.001)
    }

    @Test
    mutating func test_addDependency_sameDependencyIsOnlyAddedOnce() {
        let declarationID: DeclarationID = dummy()
        let componentID: ComponentID = dummy()
        sut.addDependency(componentID: componentID, declarationID: declarationID)
        sut.addDependency(componentID: componentID, declarationID: declarationID)
        #expect((1) == (sut.fanOut))
    }

    @Test
    mutating func test_addDependent_sameDependencyIsOnlyAddedOnce() {
        let declarationID: DeclarationID = dummy()
        let componentID: ComponentID = dummy()
        sut.addDependent(componentID: componentID, declarationID: declarationID)
        sut.addDependent(componentID: componentID, declarationID: declarationID)
        #expect((1) == (sut.fanIn))
    }
}
