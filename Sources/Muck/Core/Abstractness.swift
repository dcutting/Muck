struct Abstractness {

    var abstracts = [String]()
    var concretes = [String]()

    var numberClasses: Int {
        return numberAbstracts + concretes.count
    }

    var numberAbstracts: Int {
        return abstracts.count
    }

    var abstractness: Double {
        precondition(numberClasses >= numberAbstracts, "numberClasses < numberAbstracts")
        precondition(numberClasses > 0, "numberClasses == 0")
        return Double(numberAbstracts) / Double(numberClasses)
    }

    mutating func addAbstract(_ name: String) {
        abstracts.append(name)
    }

    mutating func addConcrete(_ name: String) {
        concretes.append(name)
    }
}
