class AbstractnessReporter: Reporter {

    func makeReport(for mainSequence: MainSequence) -> String {

        var lines = [String]()

        for component in mainSequence.components {

            lines.append("\(component.name)")
            for declaration in component.abstractness.abstracts {
                lines.append("  - [A] \(declaration)")
            }
            for declaration in component.abstractness.concretes {
                lines.append("  - \(declaration)")
            }
        }

        return lines.joined(separator: "\n")
    }
}
