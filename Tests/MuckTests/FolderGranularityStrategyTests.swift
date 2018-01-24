import XCTest
@testable import Muck

class FolderGranularityStrategyTests: XCTestCase {

    var sut: FolderGranularityStrategy!

    override func setUp() {
        sut = FolderGranularityStrategy()
    }

    func test_findComponentID_returnsDeepestPath() {
        let path = "/path/to/component/file.swift"
        let sourceFile = SourceFile(path: path, module: any(), declarations: any(), references: any())
        XCTAssertEqual("/path/to/component", sut.findComponentID(for: sourceFile))
    }

    func test_description() {
        XCTAssertEqual("treat folders as components", sut.description)
    }
}
