class DotDependencyReporter: Reporter {

    var name: String {
        return "Dot Dependencies"
    }

    func makeReport(for mainSequence: MainSequence) -> String {

        let components = mainSequence.components.sorted { $0.name < $1.name }
        let edges = components.map { component -> [String] in
            let dependencies = component.references.dependencies.map { dependency -> String in
                let referencedComponent = mainSequence.components.first { $0.componentID == dependency.componentID }
                let src = component.name
                let dst = referencedComponent?.name ?? "<extern>"
                return "  \"\(src)\" -> \"\(dst)\""
            }
            return dependencies
        }
        let result = ["digraph {"] + edges.flattened() + ["}"]
        return result.joined(separator: "\n")
    }
}
