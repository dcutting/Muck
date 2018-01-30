import Foundation
@testable import Muck

func any() -> String {
    return "dummy"
}

func any() -> [String] {
    return []
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

func any() -> GranularityStrategy {

    class TestGranularityStrategy: GranularityStrategy {
        func findComponentID(for file: SourceFile, entity: Entity) -> ComponentID {
            return any()
        }
        var description = ""
    }

    return TestGranularityStrategy()
}

func any() -> ComponentNameStrategy {

    class TestComponentNameStrategy: ComponentNameStrategy {
        func findComponentName(for componentID: ComponentID) -> String {
            return any()
        }
        var description = ""
    }

    return TestComponentNameStrategy()
}

func any() -> Raker.Arguments {
    return Raker.Arguments(path: any(), xcodeBuildArguments: any(), moduleNames: any(), isVerbose: any(), granularityStrategy: any(), componentNameStrategy: any(), shouldIgnoreExternalDependencies: any())
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

func any() -> [Reporter] {
    return []
}

func any() -> Reporter {
    return StubReporter(name: any(), report: { _ in "" })
}

func any() -> Declarations {
    return Declarations()
}

func any() -> References {
    return References()
}

func any() -> MainSequence {
    return MainSequence(components: [])
}

class StubReporter: Reporter {

    let name: String
    let report: (MainSequence) -> String

    init(name: String, report: @escaping (MainSequence) -> String) {
        self.name = name
        self.report = report
    }

    func makeReport(for mainSequence: MainSequence) -> String {
        return report(mainSequence)
    }
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
