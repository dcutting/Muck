import XCTest
@testable import Muck

class StrippedComponentNameStrategyTests: XCTestCase {

    func test_findComponentName_prefixAndSuffixDoesNotMatch_returnsComponentID() {
        let sut = StrippedComponentNameStrategy(prefix: "/a/root/path", suffix: ".swift")
        let actual = sut.findComponentName(for: "/a/different/path/a-component-id")
        XCTAssertEqual("/a/different/path/a-component-id", actual)
    }

    func test_findComponentName_prefixAndSuffixMatches_returnsComponentIDStrippedOfPrefix() {
        let sut = StrippedComponentNameStrategy(prefix: "/a/root/path/", suffix: ".swift")
        let actual = sut.findComponentName(for: "/a/root/path/a-component-id.swift")
        XCTAssertEqual("a-component-id", actual)
    }

    func test_description() {
        let sut = StrippedComponentNameStrategy(prefix: any(), suffix: any())
        XCTAssertEqual("take component names by stripping common prefix and suffix", sut.description)
    }
}

