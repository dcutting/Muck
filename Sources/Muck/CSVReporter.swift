class CSVReporter {

    func makeReport(for mainSequence: MainSequence) -> String {
        let header = "Name,I,A,D"
        let rows = mainSequence.components.map(makeRow)
        return ([header] + rows).joined(separator: "\n")
    }

    func makeRow(for component: Component) -> String {
        return "\(component.name),\(component.stability.instability),\(component.abstractness.abstractness),\(component.mainSequenceDistance)"
    }
}
