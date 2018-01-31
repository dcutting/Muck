class DependencyReporter: Reporter {

    var name: String {
        return "Dependencies"
    }

    func makeReport(for mainSequence: MainSequence, declarations: [Declaration]) -> String {

        let components = mainSequence.components.map { component -> [String] in
            let dependencies = component.references.dependencies.map { dependency -> String in
                let referencedComponent = mainSequence.components.first { $0.componentID == dependency.componentID }
                let componentName = referencedComponent?.name ?? "<extern>"
                let dependencyID = dependency.declarationID
                return "  - [\(componentName)] \(declarations.findName(for: dependencyID))"
            }
            return ["\(component.name)"] + dependencies.sorted()
        }
        return components.flattened().joined(separator: "\n")
    }
}
