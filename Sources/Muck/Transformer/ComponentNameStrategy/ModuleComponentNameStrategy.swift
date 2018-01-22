class ModuleComponentNameStrategy: ComponentNameStrategy {
    func findComponentName(for componentID: ComponentID) -> String {
        return componentID
    }
}
