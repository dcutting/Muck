class ModuleGranularityStrategy: GranularityStrategy {

    func findComponentID(for declaration: Declaration) -> ComponentID {
        return declaration.module
    }

    var description: String {
        return "treat modules as components"
    }
}
