class DependencyReporter: Reporter {

    private let componentNameStrategy: ComponentNameStrategy

    init(componentNameStrategy: ComponentNameStrategy) {
        self.componentNameStrategy = componentNameStrategy
    }

    func makeReport(for mainSequence: MainSequence) -> String {

        let components = mainSequence.components.map { component -> [String] in
            let dependencies = component.references.dependencies.map { dependency -> String in
                var componentName = "<extern>"
                if let componentID = dependency.value.0 {
                    componentName = componentNameStrategy.findComponentName(for: componentID)
                }
                let typeName = dependency.value.1 ?? dependency.key
                return "  - \(componentName).\(typeName)"
            }
            return ["\(component.name)"] + dependencies
        }
        return components.flattened().joined(separator: "\n")
    }
}
