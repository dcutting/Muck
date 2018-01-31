import XCTest
@testable import Muck

class ModuleComponentNameStrategyTests: XCTestCase {

    var sut: IdentityComponentNameStrategy!

    override func setUp() {
        sut = IdentityComponentNameStrategy()
    }

    func test_findComponentName_returnsComponentID() {
        XCTAssertEqual("a-component-id", sut.findComponentName(for: "a-component-id"))
    }

    func test_description() {
        XCTAssertEqual("use component IDs as names", sut.description)
    }
}
