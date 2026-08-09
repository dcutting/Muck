public typealias DeclarationID = String

public enum DeclarationKind {
    case declaration(DeclarationID)
    case file
}

public struct Declaration {
    public let kind: DeclarationKind
    public let path: String
    public let module: String
    public let name: String
    public let isAbstract: Bool
    public let declarations: [Declaration]
    public let references: [DeclarationID]

    public init(kind: DeclarationKind, path: String, module: String, name: String,
                isAbstract: Bool, declarations: [Declaration], references: [DeclarationID]) {
        self.kind = kind
        self.path = path
        self.module = module
        self.name = name
        self.isAbstract = isAbstract
        self.declarations = declarations
        self.references = references
    }
}

public extension Array where Element == Declaration {

    func findName(for declarationID: DeclarationID) -> String {
        let declaration = findDeclaration(for: declarationID)
        return declaration?.name ?? declarationID
    }

    func findDeclaration(for declarationID: DeclarationID) -> Declaration? {
        return findDeclaration(with: declarationID, in: self)
    }

    private func findDeclaration(with declarationID: DeclarationID, in declarations: [Declaration]) -> Declaration? {
        for declaration in declarations {
            if case .declaration(let id) = declaration.kind {
                if id == declarationID {
                    return declaration
                }
            }
            if let found = findDeclaration(with: declarationID, in: declaration.declarations) {
                return found
            }
        }
        return nil
    }
}
