import Testing
@testable import Muck

struct CollectionTests {

    @Test
    func test_flattened_emptyElements_returnsEmpty() {
        let input: [[Int]] = [[]]
        let actual: [Int] = input.flattened()
        let expected: [Int] = []
        #expect((expected) == (actual))
    }

    @Test
    func test_flattened() {
        let input: [[Int]] = [[5, 4], [1], [], [4, 3, 6]]
        let actual: [Int] = input.flattened()
        let expected: [Int] = [5, 4, 1, 4, 3, 6]
        #expect((expected) == (actual))
    }
}
