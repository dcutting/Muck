public struct MainSequence {

    public let components: [Component]
    public let declarations: [Declaration]

    public init(components: [Component], declarations: [Declaration]) {
        self.components = components
        self.declarations = declarations
    }
}

public extension MainSequence {

    var mean: Double? {
        return distances.mean
    }

    var median: Double? {
        return distances.median
    }

    var standardDeviation: Double? {
        return distances.standardDeviation
    }

    private var distances: [Double] {
        return components.map { $0.distance }
    }
}

public extension Component {
    var distance: Double {
        return (references.instability + types.abstractness - 1).magnitude
    }
}
