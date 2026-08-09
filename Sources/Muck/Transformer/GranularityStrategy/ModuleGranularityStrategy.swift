public class ModuleGranularityStrategy: GranularityStrategy {

    public init() {}

    public func findComponentID(for declaration: Declaration) -> ComponentID {
        return declaration.module
    }

    public var description: String {
        return "treat modules as components"
    }
}
