import XCTest
@testable import Muck

class DeclarationReporterTests: XCTestCase {

    func test_name() {
        let sut = DeclarationReporter()
        XCTAssertEqual("Declarations", sut.name)
    }

    func test_makeReport() {
        let sut = DeclarationReporter()

        var loraxDeclarations = Declarations()
        loraxDeclarations.addAbstract("GluppityGlup")
        loraxDeclarations.addAbstract("SchloppitySchlopp")
        loraxDeclarations.addConcrete("SwomeeSwan")
        loraxDeclarations.addConcrete("Barbaloot")
        let lorax = Component(name: "Lorax", declarations: loraxDeclarations, references: any())

        var catDeclarations = Declarations()
        catDeclarations.addConcrete("Hat")
        let cat = Component(name: "Cat", declarations: catDeclarations, references: any())

        let components = [lorax, cat]
        let mainSequence = MainSequence(components: components)
        let actual = sut.makeReport(for: mainSequence)
        let expected = """
Lorax
  - [A] GluppityGlup
  - [A] SchloppitySchlopp
  - Barbaloot
  - SwomeeSwan
Cat
  - Hat
"""
        XCTAssertEqual(expected, actual)
    }
}
