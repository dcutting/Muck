import XCTest
@testable import Muck

class SystemCleanlinessReporterTests: XCTestCase {

    func test_name() {
        let sut = SystemCleanlinessReporter()
        XCTAssertEqual("System Cleanliness", sut.name)
    }

    func test_makeReport_noComponents() {
        let sut = SystemCleanlinessReporter()
        let mainSequence = MainSequence(components: [], declarations: any())
        let actual = sut.makeReport(for: mainSequence)
        XCTAssertEqual("", actual)
    }

    func test_makeReport() {
        let sut = SystemCleanlinessReporter()
        let expected = """
Count,3
Mean,0.2792
Median,0.4000
Stddev,0.1980
Rating,C
"""
        let components = makeTestComponents()
        let mainSequence = MainSequence(components: components, declarations: any())
        let actual = sut.makeReport(for: mainSequence)

        XCTAssertEqual(expected, actual)
    }
}
