class FileGranularityStrategy: GranularityStrategy {

    func findComponentID(for declaration: Declaration) -> ComponentID {
        return declaration.path
    }

    var description: String {
        return "treat files as components"
    }
}
