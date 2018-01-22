class ModuleComponentNameFactory: ComponentNameStrategy {
    func makeComponentName(for componentID: ComponentID) -> String {
        return componentID
    }
}
