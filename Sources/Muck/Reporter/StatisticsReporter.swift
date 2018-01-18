class StatisticsReporter {

    func makeReport(for mainSequence: MainSequence) -> String {
        let distances = mainSequence.distances
        guard
            let mean = distances.mean,
            let median = distances.median,
            let standardDeviation = distances.standardDeviation
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
