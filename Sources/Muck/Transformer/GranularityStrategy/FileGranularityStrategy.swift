class FileGranularityStrategy: GranularityStrategy {

    func findComponentID(for file: SourceFile, entity _: Entity) -> ComponentID {
        return file.path
    }

    var description: String {
        return "treat files as components"
    }
}
