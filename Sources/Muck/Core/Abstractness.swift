struct Abstractness {

    let numberClasses: UInt
    let numberAbstracts: UInt

    var abstractness: Double {
        precondition(numberClasses >= numberAbstracts, "numberClasses < numberAbstracts")
        precondition(numberClasses > 0, "numberClasses == 0")
        return Double(numberAbstracts) / Double(numberClasses)
    }
}
