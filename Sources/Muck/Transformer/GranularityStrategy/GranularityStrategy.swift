protocol GranularityStrategy: CustomStringConvertible {
    func findComponentID(for file: SourceFile) -> ComponentID
}
