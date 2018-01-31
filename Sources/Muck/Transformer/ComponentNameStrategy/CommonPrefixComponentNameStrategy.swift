class CommonPrefixComponentNameStrategy: ComponentNameStrategy {

    private let rootPath: String

    init(rootPath: String) {
        self.rootPath = rootPath
    }

    func findComponentName(for componentID: ComponentID) -> String {
        let hasPrefix = componentID.hasPrefix(rootPath)
        if hasPrefix {
            return String(componentID.dropFirst(rootPath.count))
        }
        return componentID
    }

    var description: String {
        return "take component names by stripping common prefix"
    }
}
