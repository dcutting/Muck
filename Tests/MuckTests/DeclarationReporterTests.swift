import XCTest
@testable import Muck

class DeclarationReporterTests: XCTestCase {

    func test_name() {
        let sut = DeclarationReporter()
        XCTAssertEqual("Declarations", sut.name)
    }

    func test_makeReport() {
        let sut = DeclarationReporter()

        var loraxTypes = Types()
        loraxTypes.addAbstract("GluppityGlup")
        loraxTypes.addAbstract("SchloppitySchlopp")
        loraxTypes.addConcrete("SwomeeSwan")
        loraxTypes.addConcrete("Barbaloot")
        let lorax = Component(componentID: dummy(), name: "Lorax", types: loraxTypes, references: any())

        var catTypes = Types()
        catTypes.addConcrete("Hat")
        let cat = Component(componentID: dummy(), name: "Cat", types: catTypes, references: any())

        let components = [lorax, cat]
        let mainSequence = MainSequence(components: components, declarations: any())
        let actual = sut.makeReport(for: mainSequence)
        let expected = """
Cat
  - Hat
Lorax
  - [A] GluppityGlup
  - [A] SchloppitySchlopp
  - Barbaloot
  - SwomeeSwan
"""
        XCTAssertEqual(expected, actual)
    }
}
