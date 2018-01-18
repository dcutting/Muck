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

let mainSequence = MainSequence(components: components)
print(CSVReporter().makeReport(for: mainSequence, sortBy: .distance))
print(StatisticsReporter().makeReport(for: mainSequence))

//[1,2.9,3,4].mean
//[1,2,3,4].mean
