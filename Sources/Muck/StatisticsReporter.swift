class StatisticsReporter {

    func makeReport(for mainSequence: MainSequence) -> String {
        let distances = mainSequence.distances
        guard
            let mean = distances.mean,
            let median = distances.median
            else { return "" }
        return """
Mean,\(mean)
Median,\(median)
"""
    }
}
