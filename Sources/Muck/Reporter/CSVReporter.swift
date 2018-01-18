class CSVReporter: Reporter {

    enum SortBy {
        case name
        case distance
    }

    private let sortBy: SortBy

    init(sortBy: SortBy) {
        self.sortBy = sortBy
    }

    func makeReport(for mainSequence: MainSequence) -> String {
        let components: [Component]
        switch sortBy {
        case .name:
            components = mainSequence.components.sorted { $0.name < $1.name }
        case .distance:
            components = mainSequence.components.sorted { $0.mainSequenceDistance > $1.mainSequenceDistance }
        }
        let rows = components.map(makeRow)

        let header = "Name,I,A,D,Rating"
        return ([header] + rows).joined(separator: "\n")
    }

    func makeRow(for component: Component) -> String {
        let rating = findRating(distance: component.mainSequenceDistance)
        return "\(component.name),\(component.stability.instability),\(component.abstractness.abstractness),\(component.mainSequenceDistance),\(rating)"
    }
}
