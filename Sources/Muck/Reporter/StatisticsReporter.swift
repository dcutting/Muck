class StatisticsReporter: Reporter {

    func makeReport(for mainSequence: MainSequence) -> String {
        guard
            let mean = mainSequence.mean,
            let median = mainSequence.median,
            let standardDeviation = mainSequence.standardDeviation
            else { return "" }
        let rating = calculateRating(distance: median)
        return """
Mean,\(mean)
Median,\(median)
Stddev,\(standardDeviation)
Rating,\(rating)
"""
    }
}
