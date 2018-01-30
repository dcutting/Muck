import XCTest
@testable import Muck

class FileGranularityStrategyTests: XCTestCase {

    var sut: FileGranularityStrategy!

    override func setUp() {
        sut = FileGranularityStrategy()
    }

    func test_description() {
        XCTAssertEqual("treat files as components", sut.description)
    }

    func test_findComponentID_returnsWholePath() {
        let path = "/path/to/component/file.swift"
        let sourceFile = SourceFile(path: path, module: any(), declarations: any(), references: any())
        XCTAssertEqual("/path/to/component/file.swift", sut.findComponentID(for: sourceFile, entity: any()))
    }
}
