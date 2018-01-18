class StubFinder: Finder {

    func find() -> [Component] {
        return [
            Component(name: "Filters", stability: makeStability(), abstractness: makeAbstractness()),
            Component(name: "Discovery", stability: makeStability(), abstractness: makeAbstractness()),
            Component(name: "List", stability: makeStability(), abstractness: makeAbstractness()),
            Component(name: "Detail", stability: makeStability(), abstractness: makeAbstractness()),
            Component(name: "Share", stability: makeStability(), abstractness: makeAbstractness()),
        ]
    }

    private func makeAbstractness() -> Abstractness {
        let numberAbstracts = makeRandomUInt()
        return Abstractness(numberClasses: numberAbstracts + makeRandomUInt(), numberAbstracts: numberAbstracts)
    }

    private func makeStability() -> Stability {
        return Stability(fanIn: makeRandomUInt(), fanOut: makeRandomUInt())
    }
}
