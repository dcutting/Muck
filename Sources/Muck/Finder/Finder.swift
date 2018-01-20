typealias EntityID = String

struct Entity {
    let name: String
    let kind: String
    let usr: EntityID

    var isAbstract: Bool {
        return kind.contains(".protocol") // todo shouldn't include non-public things
    }
}

struct SourceFile {
    let path: String
    let module: String
    let declarations: [Entity]
    let references: [Entity]
}

protocol Finder {
    func find() -> [SourceFile]
}
