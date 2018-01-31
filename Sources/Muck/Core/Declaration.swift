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

extension Array where Element == Declaration {

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
