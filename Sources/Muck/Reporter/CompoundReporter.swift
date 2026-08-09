public class CompoundReporter: Reporter, CustomStringConvertible {

    private let reporters: [Reporter]

    public var name: String {
        return "Compound Report"
    }

    public var description: String {
        return reporters.map { "\($0)" }.joined(separator: ", ")
    }

    public init(reporters: [Reporter]) {
        self.reporters = reporters
    }

    public func makeReport(for mainSequence: MainSequence) -> String {
        let maker = reporters.count == 1 ? makeSansName : makeWithName
        return reporters.map { maker(mainSequence, $0) }.joined(separator: "\n-----\n")
    }

    private func makeSansName(mainSequence: MainSequence, reporter: Reporter) -> String {
        return reporter.makeReport(for: mainSequence)
    }

    private func makeWithName(mainSequence: MainSequence, reporter: Reporter) -> String {
        return "# \(reporter.name)\n" + reporter.makeReport(for: mainSequence)
    }
}
