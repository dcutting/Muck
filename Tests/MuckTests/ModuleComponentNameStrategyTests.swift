import XCTest
@testable import Muck

class ModuleComponentNameStrategyTests: XCTestCase {

    var sut: ModuleComponentNameStrategy!

    override func setUp() {
        sut = ModuleComponentNameStrategy()
    }

    func test_findComponentName_returnsComponentID() {
        XCTAssertEqual("a-component-id", sut.findComponentName(for: "a-component-id"))
    }

    func test_description() {
        XCTAssertEqual("take component names from modules", sut.description)
    }
}
