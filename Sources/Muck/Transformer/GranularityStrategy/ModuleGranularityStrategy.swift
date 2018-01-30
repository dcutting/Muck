class ModuleGranularityStrategy: GranularityStrategy {

    func findComponentID(for file: SourceFile, entity _: Entity) -> ComponentID {
        return file.module
    }

    var description: String {
        return "treat modules as components"
    }
}
