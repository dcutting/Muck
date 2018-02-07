import XCTest
@testable import Muck

class ComponentCleanlinessReporterTests: XCTestCase {

    func test_name() {
        let sut = ComponentCleanlinessReporter(sortBy: any())
        XCTAssertEqual("Component Cleanliness", sut.name)
    }

    func test_makeReport_sortedByName() {
        let sut = ComponentCleanlinessReporter(sortBy: .name)
        let expected = """
Name,FanIn,FanOut,I,Nc,Na,A,D
"Bar",1,3,0.7500,4,1,0.2500,0.0000
"Baz",2,0,0.0000,5,3,0.6000,0.4000
"Foo",7,9,0.5625,1,0,0.0000,0.4375
"""
        let components = makeTestComponents()
        let mainSequence = MainSequence(components: components, declarations: any())
        let actual = sut.makeReport(for: mainSequence)

        XCTAssertEqual(expected, actual)
    }

    func test_makeReport_sortedByDistance() {
        let sut = ComponentCleanlinessReporter(sortBy: .distance)
        let expected = """
Name,FanIn,FanOut,I,Nc,Na,A,D
"Foo",7,9,0.5625,1,0,0.0000,0.4375
"Baz",2,0,0.0000,5,3,0.6000,0.4000
"Bar",1,3,0.7500,4,1,0.2500,0.0000
"""
        let components = makeTestComponents()
        let mainSequence = MainSequence(components: components, declarations: any())
        let actual = sut.makeReport(for: mainSequence)

        XCTAssertEqual(expected, actual)
    }
}
