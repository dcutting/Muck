import XCTest
@testable import Muck

class FolderGranularityStrategyTests: XCTestCase {

    var sut: FolderGranularityStrategy!

    override func setUp() {
        sut = FolderGranularityStrategy()
    }

    func test_findComponentID_returnsDeepestPath() {
        let path = "/path/to/component/file.swift"
        let declaration = Declaration(kind: any(), path: path, module: any(), name: any(), isAbstract: any(), declarations: any(), references: any())
        XCTAssertEqual("/path/to/component", sut.findComponentID(for: declaration))
    }

    func test_description() {
        XCTAssertEqual("treat folders as components", sut.description)
    }
}
