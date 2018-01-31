typealias DeclarationID = String

enum DeclarationKind {
    case declaration(DeclarationID)
    case file
}

struct Declaration {
    let kind: DeclarationKind
    let path: String
    let module: String
    let name: String
    let isAbstract: Bool
    let declarations: [Declaration]
    let references: [DeclarationID]
}
