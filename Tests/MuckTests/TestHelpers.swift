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

func any() -> DeclarationKind {
    return .file
}

func any() -> Declaration {
    return Declaration(kind: any(), path: any(), module: any(), name: any(), isAbstract: any(), declarations: any(), references: any())
}

func any() -> ComponentCleanlinessReporter.SortBy {
    return .name
}

func any() -> GranularityStrategy {

    class TestGranularityStrategy: GranularityStrategy {
        func findComponentID(for declaration: Declaration) -> ComponentID {
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

func dummy() -> Declaration {
    return Declaration(kind: .declaration(dummy()), path: any(), module: any(), name: any(), isAbstract: any(), declarations: any(), references: any())
}

func any() -> [Declaration] {
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
    fooReferences.addDependency(componentID: dummy(), declarationID: dummy())
    fooReferences.addDependency(componentID: dummy(), declarationID: dummy())
    fooReferences.addDependency(componentID: dummy(), declarationID: dummy())
    fooReferences.addDependency(componentID: dummy(), declarationID: dummy())
    fooReferences.addDependency(componentID: dummy(), declarationID: dummy())
    fooReferences.addDependency(componentID: dummy(), declarationID: dummy())
    fooReferences.addDependency(componentID: dummy(), declarationID: dummy())
    fooReferences.addDependency(componentID: dummy(), declarationID: dummy())
    fooReferences.addDependency(componentID: dummy(), declarationID: dummy())
    fooReferences.addDependent(componentID: dummy(), declarationID: dummy())
    fooReferences.addDependent(componentID: dummy(), declarationID: dummy())
    fooReferences.addDependent(componentID: dummy(), declarationID: dummy())
    fooReferences.addDependent(componentID: dummy(), declarationID: dummy())
    fooReferences.addDependent(componentID: dummy(), declarationID: dummy())
    fooReferences.addDependent(componentID: dummy(), declarationID: dummy())
    fooReferences.addDependent(componentID: dummy(), declarationID: dummy())

    var barDeclarations = Declarations()
    barDeclarations.addAbstract(dummy())
    barDeclarations.addConcrete(dummy())
    barDeclarations.addConcrete(dummy())
    barDeclarations.addConcrete(dummy())
    var barReferences = References()
    barReferences.addDependency(componentID: dummy(), declarationID: dummy())
    barReferences.addDependency(componentID: dummy(), declarationID: dummy())
    barReferences.addDependency(componentID: dummy(), declarationID: dummy())
    barReferences.addDependent(componentID: dummy(), declarationID: dummy())

    var bazDeclarations = Declarations()
    bazDeclarations.addAbstract(dummy())
    bazDeclarations.addAbstract(dummy())
    bazDeclarations.addAbstract(dummy())
    bazDeclarations.addConcrete(dummy())
    bazDeclarations.addConcrete(dummy())
    var bazReferences = References()
    bazReferences.addDependent(componentID: dummy(), declarationID: dummy())
    bazReferences.addDependent(componentID: dummy(), declarationID: dummy())

    let components = [
        Component(componentID: "foo", name: "Foo", declarations: fooDeclarations, references: fooReferences),
        Component(componentID: "bar", name: "Bar", declarations: barDeclarations, references: barReferences),
        Component(componentID: "baz", name: "Baz", declarations: bazDeclarations, references: bazReferences)
    ]

    return components
}
