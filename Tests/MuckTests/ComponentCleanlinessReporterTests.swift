import XCTest
@testable import Muck

class ComponentCleanlinessReporterTests: XCTestCase {

    func test_name() {
        let sut = ComponentCleanlinessReporter(sortBy: any())
        XCTAssertEqual("Component Cleanliness", sut.name)
    }

    func test_makeReport_sortedByName() {
        let sut = ComponentCleanlinessReporter(sortBy: .name)
        let expected = """
Name,FanIn,FanOut,I,Nc,Na,A,D,Rating
Bar,1,3,0.75,4,1,0.25,0.0,A
Foo,7,9,0.5625,1,0,0.0,0.4375,C
"""
        let components = makeComponents()
        let mainSequence = MainSequence(components: components)
        let actual = sut.makeReport(for: mainSequence)

        XCTAssertEqual(expected, actual)
    }

    func test_makeReport_sortedByDistance() {
        let sut = ComponentCleanlinessReporter(sortBy: .distance)
        let expected = """
Name,FanIn,FanOut,I,Nc,Na,A,D,Rating
Foo,7,9,0.5625,1,0,0.0,0.4375,C
Bar,1,3,0.75,4,1,0.25,0.0,A
"""
        let components = makeComponents()
        let mainSequence = MainSequence(components: components)
        let actual = sut.makeReport(for: mainSequence)

        XCTAssertEqual(expected, actual)
    }

    private func makeComponents() -> [Component] {

        var fooDeclarations = Declarations()
        fooDeclarations.addConcrete(dummy())
        var fooReferences = References()
        fooReferences.addDependency(on: dummy(), ownedBy: dummy())
        fooReferences.addDependency(on: dummy(), ownedBy: dummy())
        fooReferences.addDependency(on: dummy(), ownedBy: dummy())
        fooReferences.addDependency(on: dummy(), ownedBy: dummy())
        fooReferences.addDependency(on: dummy(), ownedBy: dummy())
        fooReferences.addDependency(on: dummy(), ownedBy: dummy())
        fooReferences.addDependency(on: dummy(), ownedBy: dummy())
        fooReferences.addDependency(on: dummy(), ownedBy: dummy())
        fooReferences.addDependency(on: dummy(), ownedBy: dummy())
        fooReferences.addDependency(on: dummy(), from: dummy())
        fooReferences.addDependency(on: dummy(), from: dummy())
        fooReferences.addDependency(on: dummy(), from: dummy())
        fooReferences.addDependency(on: dummy(), from: dummy())
        fooReferences.addDependency(on: dummy(), from: dummy())
        fooReferences.addDependency(on: dummy(), from: dummy())
        fooReferences.addDependency(on: dummy(), from: dummy())

        var barDeclarations = Declarations()
        barDeclarations.addAbstract(dummy())
        barDeclarations.addConcrete(dummy())
        barDeclarations.addConcrete(dummy())
        barDeclarations.addConcrete(dummy())
        var barReferences = References()
        barReferences.addDependency(on: dummy(), ownedBy: dummy())
        barReferences.addDependency(on: dummy(), ownedBy: dummy())
        barReferences.addDependency(on: dummy(), ownedBy: dummy())
        barReferences.addDependency(on: dummy(), from: dummy())

        let components = [
            Component(name: "Foo", declarations: fooDeclarations, references: fooReferences),
            Component(name: "Bar", declarations: barDeclarations, references: barReferences)
        ]

        return components
    }
}
