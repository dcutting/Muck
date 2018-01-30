protocol GranularityStrategy: CustomStringConvertible {
    func findComponentID(for file: SourceFile, entity: Entity) -> ComponentID
}
