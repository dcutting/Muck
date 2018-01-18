import Foundation

func makeRandomUInt() -> UInt {
    return UInt(arc4random_uniform(20)) + 1
}

func makeAbstractness() -> Abstractness {
    let numberAbstracts = makeRandomUInt()
    return Abstractness(numberClasses: numberAbstracts + makeRandomUInt(), numberAbstracts: numberAbstracts)
}

func makeStability() -> Stability {
    return Stability(fanIn: makeRandomUInt(), fanOut: makeRandomUInt())
}

let components: [Component] = [
    Component(name: "Filters", stability: makeStability(), abstractness: makeAbstractness()),
    Component(name: "Discovery", stability: makeStability(), abstractness: makeAbstractness()),
    Component(name: "List", stability: makeStability(), abstractness: makeAbstractness()),
    Component(name: "Detail", stability: makeStability(), abstractness: makeAbstractness()),
    Component(name: "Share", stability: makeStability(), abstractness: makeAbstractness()),
]

//let mainSequence = MainSequence(components: components)
//print(CSVReporter().makeReport(for: mainSequence))
//print(StatisticsReporter().makeReport(for: mainSequence))




let a = [1, 2, 12, 8, 5]
print("\(String(describing: a.median))")

let b = [1.2, 5.2, 92, 5.3]
print("\(String(describing: b.median))")

