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
            components = mainSequence.components.sorted { $0.distance > $1.distance }
        }
        let rows = components.map(makeRow)

        let header = "Name,FanIn,FanOut,I,Nc,Na,A,D,Rating"
        return ([header] + rows).joined(separator: "\n")
    }

    private func makeRow(for component: Component) -> String {
        let stability = component.stability
        let abstractness = component.abstractness
        let rating = calculateRating(distance: component.distance)
        return "\(component.name),\(stability.fanIn),\(stability.fanOut),\(stability.instability),\(abstractness.numberClasses),\(abstractness.numberAbstracts),\(abstractness.abstractness),\(component.distance),\(rating)"
    }
}
