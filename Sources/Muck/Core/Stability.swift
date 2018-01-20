struct Stability {

    var fanIns = [(ComponentID, EntityID)]()
    var fanOuts = [EntityID: (ComponentID?, String?)]()

    var fanIn: Int {
        return fanIns.count
    }

    var fanOut: Int {
        return fanOuts.count
    }

    var instability: Double {
        let fanTotal = fanIn + fanOut
        precondition(fanTotal > 0, "fanIn + fanOut == 0")
        return Double(fanOut) / Double(fanTotal)
    }

    mutating func addDependency(_ entityID: EntityID, componentID: ComponentID?, name: String?) {
        guard nil == fanOuts[entityID] else { return }
        fanOuts[entityID] = (componentID, name)
    }

    mutating func addDependent(_ componentID: ComponentID, entityID: EntityID) {
        fanIns.append((componentID, entityID))
    }
}
