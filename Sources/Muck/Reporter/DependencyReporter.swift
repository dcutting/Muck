class DependencyReporter: Reporter {

    var name: String {
        return "Dependencies"
    }

    func makeReport(for mainSequence: MainSequence) -> String {

        let components = mainSequence.components.sorted { $0.name < $1.name }
        let componentReport = components.map { component -> [String] in
            let dependencies = component.references.dependencies.map { dependency -> String in
                let referencedComponent = mainSequence.components.first { $0.componentID == dependency.componentID }
                let componentName = referencedComponent?.name ?? "<extern>"
                let dependencyID = dependency.declarationID
                return "  - \(componentName)::\(mainSequence.declarations.findName(for: dependencyID))"
            }
            return ["\(component.name)"] + dependencies.sorted()
        }
        return componentReport.flattened().joined(separator: "\n")
    }
}
