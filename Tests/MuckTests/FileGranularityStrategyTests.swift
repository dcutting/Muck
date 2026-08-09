import Testing
@testable import Muck

struct FileGranularityStrategyTests {

    let sut = FileGranularityStrategy()

    @Test
    mutating func test_description() {
        #expect(("treat files as components") == (sut.description))
    }

    @Test
    mutating func test_findComponentID_returnsWholePath() {
        let path = "/path/to/component/file.swift"
        let declaration = Declaration(kind: .file, path: path, module: any(), name: any(), isAbstract: any(), declarations: any(), references: any())
        #expect(("/path/to/component/file.swift") == (sut.findComponentID(for: declaration)))
    }
}
