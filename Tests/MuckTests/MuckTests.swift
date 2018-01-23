import XCTest
import Muck

class MuckTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        let muck = MuckApp()
        XCTAssertNotNil(muck)
    }


    static var allTests = [
        ("testExample", testExample),
    ]
}
