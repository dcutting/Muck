import XCTest
@testable import Muck

class OverallCleanlinessReporterTests: XCTestCase {

    func test_name() {
        let sut = OverallCleanlinessReporter()
        XCTAssertEqual("Overall Cleanliness", sut.name)
    }

    func test_makeReport_noComponents() {
        let sut = OverallCleanlinessReporter()
        let mainSequence = MainSequence(components: [])
        let actual = sut.makeReport(for: mainSequence)
        XCTAssertEqual("", actual)
    }

    func test_makeReport() {
        let sut = OverallCleanlinessReporter()
        let expected = """
Count,3
Mean,0.2792
Median,0.4000
Stddev,0.1980
Rating,C
"""
        let components = makeTestComponents()
        let mainSequence = MainSequence(components: components)
        let actual = sut.makeReport(for: mainSequence)

        XCTAssertEqual(expected, actual)
    }
}
