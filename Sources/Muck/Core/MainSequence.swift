struct MainSequence {

    let components: [Component]
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
        return (stability.instability + abstractness.abstractness - 1).magnitude
    }
}