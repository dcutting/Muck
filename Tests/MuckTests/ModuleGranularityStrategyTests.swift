import XCTest
@testable import Muck

class ModuleGranularityStrategyTests: XCTestCase {

    var sut: ModuleGranularityStrategy!

    override func setUp() {
        sut = ModuleGranularityStrategy()
    }

    func test_findComponentID_returnsModuleName() {
        let sourceFile = SourceFile(path: any(), module: "my_module", declarations: any(), references: any())
        XCTAssertEqual("my_module", sut.findComponentID(for: sourceFile, entity: any()))
    }

    func test_description() {
        XCTAssertEqual("treat modules as components", sut.description)
    }
}
