class ModuleGranularityStrategy: GranularityStrategy {
    func findComponentID(for file: SourceFile) -> ComponentID {
        return file.module
    }

    var description: String {
        return "components by module"
    }
}