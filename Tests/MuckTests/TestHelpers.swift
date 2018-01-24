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
