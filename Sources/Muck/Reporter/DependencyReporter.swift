class DependencyReporter: Reporter {

    func makeReport(for mainSequence: MainSequence) -> String {

        let components = mainSequence.components.map { component -> [String] in
            let dependencies = component.stability.fanOuts.map { dependency -> String in
                let componentName = dependency.value.0 ?? "<extern>"
                let typeName = dependency.value.1 ?? dependency.key
                return "  - \(componentName).\(typeName)"
            }
            return ["\(component.name)"] + dependencies
        }
        return Array(components.joined()).joined(separator: "\n")
    }
}
