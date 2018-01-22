protocol SourceFileFinder {
    func find() throws -> [SourceFile]
}

struct SourceFile {
    let path: String
    let module: String
    let declarations: [Entity]
    let references: [Entity]
}

struct Entity {
    let name: String
    let kind: String
    let usr: EntityID

    var isAbstract: Bool {
        return kind.contains(".protocol")
    }

    var isDeclaration: Bool {
        return kind.contains(".decl.")
    }
}

typealias EntityID = String
