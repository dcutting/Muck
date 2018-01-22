typealias EntityID = String

struct Entity {
    let name: String
    let kind: String
    let usr: EntityID

    var isAbstract: Bool {
        return kind.contains(".protocol")
    }
}

struct SourceFile {
    let path: String
    let module: String
    let declarations: [Entity]
    let references: [Entity]
}

enum FinderError: Error {
    case build(name: String)
}

protocol Finder {
    func find() throws -> [SourceFile]
}
