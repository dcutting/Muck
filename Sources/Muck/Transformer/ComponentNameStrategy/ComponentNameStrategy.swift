protocol ComponentNameStrategy: CustomStringConvertible {
    func findComponentName(for componentID: ComponentID) -> String
}
