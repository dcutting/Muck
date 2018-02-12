class StrippedComponentNameStrategy: ComponentNameStrategy {

    private let prefix: String
    private let suffix: String

    init(prefix: String, suffix: String) {
        self.prefix = prefix
        self.suffix = suffix
    }

    func findComponentName(for componentID: ComponentID) -> String {
        return componentID.strip(prefix: prefix, suffix: suffix)
    }

    var description: String {
        return "take component names by stripping common prefix and suffix"
    }
}
