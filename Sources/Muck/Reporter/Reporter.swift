protocol Reporter {
    var name: String { get }
    func makeReport(for: MainSequence) -> String
}
