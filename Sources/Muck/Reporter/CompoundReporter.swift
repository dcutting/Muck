class CompoundReporter: Reporter {

    private let reporters: [Reporter]

    var name: String {
        return "Compound Report"
    }

    init(reporters: [Reporter]) {
        self.reporters = reporters
    }

    func makeReport(for mainSequence: MainSequence) -> String {
        return reporters.map { "# \($0.name)\n" + $0.makeReport(for: mainSequence) }.joined(separator: "\n-----\n")
    }
}
