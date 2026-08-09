public class TypeGranularityStrategy: GranularityStrategy {

    public init() {}

    public func findComponentID(for declaration: Declaration) -> ComponentID {
        return "\(declaration.module).\(declaration.name)"
    }

    public var description: String {
        return "treat types as components"
    }
}
