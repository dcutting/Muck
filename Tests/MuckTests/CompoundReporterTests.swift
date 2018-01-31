import XCTest
@testable import Muck

class CompoundReporterTests: XCTestCase {

    func test_name() {
        let sut = CompoundReporter(reporters: any())
        XCTAssertEqual("Compound Report", sut.name)
    }

    func test_makeReport() {
        let stub1 = StubReporter(name: "Lorax") { mainSequence in
            let componentNames = mainSequence.components.map { $0.name }.joined()
            return "I speak for the trees: \(componentNames)"
        }
        let stub2 = StubReporter(name: "Cat in the Hat") { mainSequence in
            let componentNames = mainSequence.components.map { $0.name }.joined()
            return "We can have lots of good fun that is funny: \(componentNames)"
        }
        let sut = CompoundReporter(reporters: [stub1, stub2])
        let expected = """
# Lorax
I speak for the trees: ABCDEF
-----
# Cat in the Hat
We can have lots of good fun that is funny: ABCDEF
"""
        let mainSequence = MainSequence(components: [
            Component(componentID: "abc", name: "ABC", types: any(), references: any()),
            Component(componentID: "def", name: "DEF", types: any(), references: any())
            ], declarations: any())
        let actual = sut.makeReport(for: mainSequence)
        XCTAssertEqual(expected, actual)
    }
}
