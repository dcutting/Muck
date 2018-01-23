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

        let header = "Name,FanIn,FanOut,I,Nc,Na,A,D,Rating"
        return ([header] + rows).joined(separator: "\n")
    }

    private func makeRow(for component: Component) -> String {
        let references = component.references
        let declarations = component.declarations
        let rating = calculateRating(distance: component.distance)
        return "\(component.name),\(references.fanIn),\(references.fanOut),\(references.instability),\(declarations.numberDeclarations),\(declarations.numberAbstracts),\(declarations.abstractness),\(component.distance),\(rating)"
    }
}
