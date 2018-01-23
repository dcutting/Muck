class ModuleComponentNameStrategy: ComponentNameStrategy {
    func findComponentName(for componentID: ComponentID) -> String {
        return componentID
    }

    var description: String {
        return "take component names from modules"
    }
}
