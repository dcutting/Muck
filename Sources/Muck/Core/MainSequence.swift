struct MainSequence {

    let components: [Component]
    let declarations: [Declaration]
}

extension MainSequence {

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

extension Component {
    var distance: Double {
        return (references.instability + types.abstractness - 1).magnitude
    }
}
