class DependencyReporter: Reporter {

    func makeReport(for mainSequence: MainSequence) -> String {

        var lines = [String]()

        for component in mainSequence.components {

            lines.append("\(component.name)")
            for dependency in component.stability.fanOuts {
                lines.append("  - \(dependency)")
            }
        }

        return lines.joined(separator: "\n")
    }
}
