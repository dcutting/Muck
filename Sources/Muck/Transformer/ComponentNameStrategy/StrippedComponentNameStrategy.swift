public class StrippedComponentNameStrategy: ComponentNameStrategy {

    private let prefix: String
    private let suffix: String

    public init(prefix: String, suffix: String) {
        self.prefix = prefix
        self.suffix = suffix
    }

    public func findComponentName(for componentID: ComponentID) -> String {
        return componentID.strip(prefix: prefix, suffix: suffix)
    }

    public var description: String {
        return "take component names by stripping common prefix and suffix"
    }
}
