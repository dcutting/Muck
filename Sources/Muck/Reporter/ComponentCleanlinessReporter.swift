class ComponentCleanlinessReporter: Reporter {

    enum SortBy {
        case name
        case distance
    }

    private let sortBy: SortBy

    var name: String {
        return "Component Cleanliness"
    }

    init(sortBy: SortBy) {
        self.sortBy = sortBy
    }

    func makeReport(for mainSequence: MainSequence) -> String {
        let components = mainSequence.components.sorted {
            switch sortBy {
            case .name:
                return $0.name < $1.name
            case .distance:
                return $0.distance > $1.distance
            }
        }
        let rows = components.map(makeRow)

        let header = "Name,FanIn,FanOut,I,Nc,Na,A,D"
        return ([header] + rows).joined(separator: "\n")
    }

    private func makeRow(for component: Component) -> String {
        let references = component.references
        let types = component.types
        return "\"\(component.name)\",\(references.fanIn),\(references.fanOut),\(references.instability.formatted),\(types.numberTypes),\(types.numberAbstracts),\(types.abstractness.formatted),\(component.distance.formatted)"
    }
}
