import XCTest
@testable import Muck

class FilePathComponentNameStrategyTests: XCTestCase {

    func test_findComponentName_prefixDoesNotMatch_returnsComponentID() {
        let sut = CommonPrefixComponentNameStrategy(rootPath: "/a/root/path")
        let actual = sut.findComponentName(for: "/a/different/path/a-component-id")
        XCTAssertEqual("/a/different/path/a-component-id", actual)
    }

    func test_findComponentName_prefixMatches_returnsComponentIDStrippedOfPrefix() {
        let sut = CommonPrefixComponentNameStrategy(rootPath: "/a/root/path/")
        let actual = sut.findComponentName(for: "/a/root/path/a-component-id")
        XCTAssertEqual("a-component-id", actual)
    }

    func test_description() {
        let sut = CommonPrefixComponentNameStrategy(rootPath: any())
        XCTAssertEqual("take component names by stripping common prefix", sut.description)
    }
}

