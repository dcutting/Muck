class CompoundReporter: Reporter {

    private let reporters: [Reporter]

    init(reporters: [Reporter]) {
        self.reporters = reporters
    }

    func makeReport(for mainSequence: MainSequence) -> String {
        return reporters.map { $0.makeReport(for: mainSequence) }.joined(separator: "\n-----\n")
    }
}
