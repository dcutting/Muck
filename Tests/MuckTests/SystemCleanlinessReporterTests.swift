import Testing
@testable import MuckCore
@testable import MuckSourceKit
@testable import MuckCLI

struct SystemCleanlinessReporterTests {

    @Test
    func test_name() {
        let sut = SystemCleanlinessReporter()
        #expect(("System Cleanliness") == (sut.name))
    }

    @Test
    func test_makeReport_noComponents() {
        let sut = SystemCleanlinessReporter()
        let mainSequence = MainSequence(components: [], declarations: any())
        let actual = sut.makeReport(for: mainSequence)
        #expect(("") == (actual))
    }

    @Test
    func test_makeReport() {
        let sut = SystemCleanlinessReporter()
        let expected = """
Count,3
Mean,0.2792
Median,0.4000
Stddev,0.1980
"""
        let components = makeTestComponents()
        let mainSequence = MainSequence(components: components, declarations: any())
        let actual = sut.makeReport(for: mainSequence)

        #expect((expected) == (actual))
    }
}
