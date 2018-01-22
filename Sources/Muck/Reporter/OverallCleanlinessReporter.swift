class OverallCleanlinessReporter: Reporter {

    func makeReport(for mainSequence: MainSequence) -> String {
        guard
            let mean = mainSequence.mean,
            let median = mainSequence.median,
            let standardDeviation = mainSequence.standardDeviation
            else { return "" }
        let count = mainSequence.components.count
        let rating = calculateRating(distance: median)
        return """
Count,\(count)
Mean,\(mean)
Median,\(median)
Stddev,\(standardDeviation)
Rating,\(rating)
"""
    }
}
