protocol ComponentFinder {
    func find() -> [Component]
}

class StubComponentFinder: ComponentFinder {
    func find() -> [Component] {
        return [
            Component(name: "Filters", stability: makeStability(), abstractness: makeAbstractness()),
            Component(name: "Discovery", stability: makeStability(), abstractness: makeAbstractness()),
            Component(name: "List", stability: makeStability(), abstractness: makeAbstractness()),
            Component(name: "Detail", stability: makeStability(), abstractness: makeAbstractness()),
            Component(name: "Share", stability: makeStability(), abstractness: makeAbstractness()),
        ]
    }

    func makeAbstractness() -> Abstractness {
        let numberAbstracts = makeRandomUInt()
        return Abstractness(numberClasses: numberAbstracts + makeRandomUInt(), numberAbstracts: numberAbstracts)
    }

    func makeStability() -> Stability {
        return Stability(fanIn: makeRandomUInt(), fanOut: makeRandomUInt())
    }
}
