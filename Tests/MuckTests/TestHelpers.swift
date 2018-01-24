import Foundation
@testable import Muck

func any() -> String {
    return "dummy"
}

func any() -> Bool {
    return false
}

func any() -> Entity {
    return Entity(entityID: any(), name: any(), kind: any(), isAbstract: any(), isDeclaration: any())
}

func any() -> ComponentCleanlinessReporter.SortBy {
    return .name
}

func dummy() -> String {
    return UUID().uuidString
}

func dummy() -> Entity {
    return Entity(entityID: dummy(), name: any(), kind: any(), isAbstract: any(), isDeclaration: any())
}

func any() -> [Entity] {
    return []
}

func any() -> Reporter {

    class TestReporter: Reporter {

        var name: String = ""

        func makeReport(for: MainSequence) -> String {
            return any()
        }
    }

    return TestReporter()
}

func makeTestComponents() -> [Component] {

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

    var bazDeclarations = Declarations()
    bazDeclarations.addAbstract(dummy())
    bazDeclarations.addAbstract(dummy())
    bazDeclarations.addAbstract(dummy())
    bazDeclarations.addConcrete(dummy())
    bazDeclarations.addConcrete(dummy())
    var bazReferences = References()
    bazReferences.addDependency(on: dummy(), from: dummy())
    bazReferences.addDependency(on: dummy(), from: dummy())

    let components = [
        Component(name: "Foo", declarations: fooDeclarations, references: fooReferences),
        Component(name: "Bar", declarations: barDeclarations, references: barReferences),
        Component(name: "Baz", declarations: bazDeclarations, references: bazReferences)
    ]

    return components
}
