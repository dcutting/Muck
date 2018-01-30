class TypeGranularityStrategy: GranularityStrategy {

    func findComponentID(for declaration: Declaration) -> ComponentID {
        switch declaration.kind {
        case .file:
            return declaration.path
        case .declaration(let entityID):
            return entityID
        }
    }

    var description: String {
        return "treat types as components"
    }
}
