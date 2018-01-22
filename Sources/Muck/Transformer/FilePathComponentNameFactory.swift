class FilePathComponentNameFactory: ComponentNameStrategy {

    private let rootPath: String

    init(rootPath: String) {
        self.rootPath = rootPath
    }

    func makeComponentName(for componentID: ComponentID) -> String {
        let hasPrefix = componentID.hasPrefix(rootPath)
        if hasPrefix {
            return String(componentID.dropFirst(rootPath.count))
        } else {
            return componentID
        }
    }
}
