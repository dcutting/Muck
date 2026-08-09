import Testing
@testable import Muck

struct StrippedComponentNameStrategyTests {

    @Test
    func test_findComponentName_prefixAndSuffixDoesNotMatch_returnsComponentID() {
        let sut = StrippedComponentNameStrategy(prefix: "/a/root/path", suffix: ".swift")
        let actual = sut.findComponentName(for: "/a/different/path/a-component-id")
        #expect(("/a/different/path/a-component-id") == (actual))
    }

    @Test
    func test_findComponentName_prefixAndSuffixMatches_returnsComponentIDStrippedOfPrefix() {
        let sut = StrippedComponentNameStrategy(prefix: "/a/root/path/", suffix: ".swift")
        let actual = sut.findComponentName(for: "/a/root/path/a-component-id.swift")
        #expect(("a-component-id") == (actual))
    }

    @Test
    func test_description() {
        let sut = StrippedComponentNameStrategy(prefix: any(), suffix: any())
        #expect(("take component names by stripping common prefix and suffix") == (sut.description))
    }
}

