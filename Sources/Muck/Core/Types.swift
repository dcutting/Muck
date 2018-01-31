struct Types {

    var abstracts = [DeclarationID]()
    var concretes = [DeclarationID]()

    var numberTypes: Int {
        return numberAbstracts + concretes.count
    }

    var numberAbstracts: Int {
        return abstracts.count
    }

    var abstractness: Double {
        precondition(numberTypes >= numberAbstracts, "numberTypes < numberAbstracts")
        guard numberTypes > 0 else { return 1.0 }
        return Double(numberAbstracts) / Double(numberTypes)
    }

    mutating func addAbstract(_ declarationID: DeclarationID) {
        abstracts.append(declarationID)
    }

    mutating func addConcrete(_ declarationID: DeclarationID) {
        concretes.append(declarationID)
    }
}
