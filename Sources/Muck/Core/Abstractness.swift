struct Abstractness {

    var numberClasses: UInt = 0
    var numberAbstracts: UInt = 0

    var abstractness: Double {
        precondition(numberClasses >= numberAbstracts, "numberClasses < numberAbstracts")
        precondition(numberClasses > 0, "numberClasses == 0")
        return Double(numberAbstracts) / Double(numberClasses)
    }

    mutating func addAbstract() {
        numberAbstracts += 1
        numberClasses += 1
    }

    mutating func addNonAbstract() {
        numberClasses += 1
    }
}
