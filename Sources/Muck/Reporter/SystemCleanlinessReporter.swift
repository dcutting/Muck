public class SystemCleanlinessReporter: Reporter {

    public init() {}

    public var name: String {
        return "System Cleanliness"
    }

    public func makeReport(for mainSequence: MainSequence) -> String {
        guard
            let mean = mainSequence.mean,
            let median = mainSequence.median,
            let standardDeviation = mainSequence.standardDeviation
            else { return "" }
        let count = mainSequence.components.count
        return """
Count,\(count)
Mean,\(mean.formatted)
Median,\(median.formatted)
Stddev,\(standardDeviation.formatted)
"""
    }
}
