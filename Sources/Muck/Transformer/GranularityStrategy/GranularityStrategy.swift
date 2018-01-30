protocol GranularityStrategy: CustomStringConvertible {
    func findComponentID(for declaration: Declaration) -> ComponentID
}
