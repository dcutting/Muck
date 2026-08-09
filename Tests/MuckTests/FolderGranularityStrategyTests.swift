import Testing
@testable import Muck

struct FolderGranularityStrategyTests {

    let sut = FolderGranularityStrategy()

    @Test
    mutating func test_findComponentID_returnsDeepestPath() {
        let path = "/path/to/component/file.swift"
        let declaration = Declaration(kind: any(), path: path, module: any(), name: any(), isAbstract: any(), declarations: any(), references: any())
        #expect(("/path/to/component") == (sut.findComponentID(for: declaration)))
    }

    @Test
    mutating func test_description() {
        #expect(("treat folders as components") == (sut.description))
    }
}
