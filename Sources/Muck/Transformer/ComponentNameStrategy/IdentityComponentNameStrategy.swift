public class IdentityComponentNameStrategy: ComponentNameStrategy {

    public init() {}

    public func findComponentName(for componentID: ComponentID) -> String {
        return componentID
    }

    public var description: String {
        return "use component IDs as names"
    }
}
