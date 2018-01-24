import XCTest
@testable import Muck

class CompoundReporterTests: XCTestCase {

    func test_name() {
        let sut = CompoundReporter(reporters: any())
        XCTAssertEqual("Compound Report", sut.name)
    }
}
