class StabilityReporter: Reporter {

    func makeReport(for mainSequence: MainSequence) -> String {

        var lines = [String]()

        for component in mainSequence.components {

            lines.append("\(component.name)")
            for dependency in component.stability.fanOuts {
                let componentName = dependency.value.0 ?? "<extern>"
                let typeName = dependency.value.1 ?? dependency.key
                lines.append("  - \(componentName).\(typeName)")
            }
        }

        return lines.joined(separator: "\n")
    }
}
