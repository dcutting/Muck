struct MainSequence {
    let components: [Component]

    var distances: [Double] {
        return components.map { $0.mainSequenceDistance }
    }

    var count: Int {
        return components.count
    }

    var meanDistance: Double? {
        return distances.mean
    }

    var medianDistance: Double {
        guard count > 0 else { return 0.0 }
        let sorted = distances.sorted()
        let mid = count / 2
        if count % 2 == 0 {
            return (sorted[mid-1] + sorted[mid]) / 2.0
        }
        return sorted[mid]
    }
}

extension Component {
    var mainSequenceDistance: Double {
        return abs(stability.instability + abstractness.abstractness - 1)
    }
}
