import Testing
@testable import Muck

struct IdentityComponentNameStrategyTests {

    let sut = IdentityComponentNameStrategy()

    @Test
    mutating func test_findComponentName_returnsComponentID() {
        #expect(("a-component-id") == (sut.findComponentName(for: "a-component-id")))
    }

    @Test
    mutating func test_description() {
        #expect(("use component IDs as names") == (sut.description))
    }
}
