public struct Types {

    public var abstracts = [DeclarationID]()
    public var concretes = [DeclarationID]()

    public var numberTypes: Int {
        return numberAbstracts + concretes.count
    }

    public var numberAbstracts: Int {
        return abstracts.count
    }

    public var abstractness: Double {
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
