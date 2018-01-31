class DependencyReporter: Reporter {

    var name: String {
        return "Dependencies"
    }

    func makeReport(for mainSequence: MainSequence) -> String {

        let components = mainSequence.components.map { component -> [String] in
            let dependencies = component.references.dependencies.map { dependency -> String in
                let referencedComponent = mainSequence.components.first { $0.componentID == dependency.componentID }
                let componentName = referencedComponent?.name ?? "<extern>"
                let typeName = dependency.declarationID
                return "  - \(componentName).\(typeName)"
            }
            return ["\(component.name)"] + dependencies.sorted()
        }
        return components.flattened().joined(separator: "\n")
    }
}
