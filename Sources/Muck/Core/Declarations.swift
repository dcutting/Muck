struct Declarations {

    var abstracts = [String]()
    var concretes = [String]()

    var numberDeclarations: Int {
        return numberAbstracts + concretes.count
    }

    var numberAbstracts: Int {
        return abstracts.count
    }

    var abstractness: Double {
        precondition(numberDeclarations >= numberAbstracts, "numberDeclarations < numberAbstracts")
        precondition(numberDeclarations > 0, "numberDeclarations == 0")
        return Double(numberAbstracts) / Double(numberDeclarations)
    }

    mutating func addAbstract(_ name: String) {
        abstracts.append(name)
    }

    mutating func addConcrete(_ name: String) {
        concretes.append(name)
    }
}
