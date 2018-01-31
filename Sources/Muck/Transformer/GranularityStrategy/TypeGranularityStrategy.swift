class TypeGranularityStrategy: GranularityStrategy {

    func findComponentID(for declaration: Declaration) -> ComponentID {
        return "\(declaration.module).\(declaration.name)"
    }

    var description: String {
        return "treat types as components"
    }
}
