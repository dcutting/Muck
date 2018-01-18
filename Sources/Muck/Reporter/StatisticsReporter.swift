class StatisticsReporter: Reporter {

    func makeReport(for mainSequence: MainSequence) -> String {
        guard
            let mean = mainSequence.mean,
            let median = mainSequence.median,
            let standardDeviation = mainSequence.standardDeviation
            else { return "" }
        let rating = findRating(distance: mean)
        return """
Mean,\(mean)
Median,\(median)
Stddev,\(standardDeviation)
Rating,\(rating)
"""
    }
}
