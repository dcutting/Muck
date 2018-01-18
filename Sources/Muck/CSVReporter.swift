class CSVReporter {

    func makeReport(for mainSequence: MainSequence) -> String {
        return mainSequence.components.map(makeRow).joined(separator: "\n")
    }

    func makeRow(for component: Component) -> String {
        return "\(component.name),\(component.stability.instability),\(component.abstractness.abstractness),\(component.mainSequenceDistance)"
    }
}
