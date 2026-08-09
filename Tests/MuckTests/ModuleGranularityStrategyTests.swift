import Testing
@testable import Muck

struct ModuleGranularityStrategyTests {

    let sut = ModuleGranularityStrategy()

    @Test
    mutating func test_findComponentID_returnsModuleName() {
        let declaration = Declaration(kind: any(), path: any(), module: "my_module", name: any(), isAbstract: any(), declarations: any(), references: any())
        #expect(("my_module") == (sut.findComponentID(for: declaration)))
    }

    @Test
    mutating func test_description() {
        #expect(("treat modules as components") == (sut.description))
    }
}
