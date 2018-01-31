import XCTest
@testable import Muck

class ModuleGranularityStrategyTests: XCTestCase {

    var sut: ModuleGranularityStrategy!

    override func setUp() {
        sut = ModuleGranularityStrategy()
    }

    func test_findComponentID_returnsModuleName() {
        let declaration = Declaration(kind: any(), path: any(), module: "my_module", name: any(), isAbstract: any(), declarations: any(), references: any())
        XCTAssertEqual("my_module", sut.findComponentID(for: declaration))
    }

    func test_description() {
        XCTAssertEqual("treat modules as components", sut.description)
    }
}
