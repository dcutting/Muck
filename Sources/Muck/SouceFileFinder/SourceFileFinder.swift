protocol SourceFileFinder {
    func find() throws -> [SourceFile]
}

public struct SourceFile {
    let path: String
    let module: String
    let declarations: [Entity]
    let references: [Entity]
}

struct Entity {
    let entityID: EntityID
    let name: String
    let kind: String
    let isAbstract: Bool
    let isDeclaration: Bool
}

typealias EntityID = String
