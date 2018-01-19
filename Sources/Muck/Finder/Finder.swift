struct Entity {
    let name: String
    let kind: String
    let usr: String
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
