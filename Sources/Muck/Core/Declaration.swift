public typealias DeclarationID = String

public enum DeclarationKind: Codable {
    case declaration(DeclarationID)
    case file

    private enum CodingKeys: String, CodingKey {
        case kind
        case id
    }

    private enum Kind: String, Codable {
        case declaration
        case file
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        switch try container.decode(Kind.self, forKey: .kind) {
        case .declaration:
            self = .declaration(try container.decode(DeclarationID.self, forKey: .id))
        case .file:
            self = .file
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .declaration(let id):
            try container.encode(Kind.declaration, forKey: .kind)
            try container.encode(id, forKey: .id)
        case .file:
            try container.encode(Kind.file, forKey: .kind)
        }
    }
}

public struct Declaration: Codable {
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
