class IdentityComponentNameStrategy: ComponentNameStrategy {

    func findComponentName(for componentID: ComponentID) -> String {
        return componentID
    }

    var description: String {
        return "use component IDs as names"
    }
}
