@testable import Muck

func any() -> String {
    return "dummy"
}

func any() -> [Entity] {
    return []
}

func any() -> Reporter {

    class TestReporter: Reporter {

        var name: String = ""

        func makeReport(for: MainSequence) -> String {
            return any()
        }
    }

    return TestReporter()
}
