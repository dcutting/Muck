class FileGranularityStrategy: GranularityStrategy {

    func findComponentID(for file: SourceFile) -> ComponentID {
        return file.path
    }

    var description: String {
        return "treat files as components"
    }
}
