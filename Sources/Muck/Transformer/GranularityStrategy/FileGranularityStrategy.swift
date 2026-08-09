public class FileGranularityStrategy: GranularityStrategy {

    public init() {}

    public func findComponentID(for declaration: Declaration) -> ComponentID {
        return declaration.path
    }

    public var description: String {
        return "treat files as components"
    }
}
