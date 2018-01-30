struct Declarations {

    var abstracts = [DeclarationID]()
    var concretes = [DeclarationID]()

    var numberDeclarations: Int {
        return numberAbstracts + concretes.count
    }

    var numberAbstracts: Int {
        return abstracts.count
    }

    var abstractness: Double {
        precondition(numberDeclarations >= numberAbstracts, "numberDeclarations < numberAbstracts")
        guard numberDeclarations > 0 else { return 1.0 }
        return Double(numberAbstracts) / Double(numberDeclarations)
    }

    mutating func addAbstract(_ declarationID: DeclarationID) {
        abstracts.append(declarationID)
    }

    mutating func addConcrete(_ declarationID: DeclarationID) {
        concretes.append(declarationID)
    }
}
