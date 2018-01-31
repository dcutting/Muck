class StrippedComponentNameStrategy: ComponentNameStrategy {

    private let prefix: String
    private let suffix: String

    init(prefix: String, suffix: String) {
        self.prefix = prefix
        self.suffix = suffix
    }

    func findComponentName(for componentID: ComponentID) -> String {
        var result = componentID
        if result.hasPrefix(prefix) {
            result = String(result.dropFirst(prefix.count))
        }
        if result.hasSuffix(suffix) {
            result = String(result.dropLast(suffix.count))
        }
        return result
    }

    var description: String {
        return "take component names by stripping common prefix and suffix"
    }
}
