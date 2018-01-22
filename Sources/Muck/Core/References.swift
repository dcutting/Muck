struct References {

    var dependents = [(ComponentID, EntityID)]()
    var dependencies = [EntityID: (ComponentID?, String?)]()

    var fanIn: Int {
        return dependents.count
    }

    var fanOut: Int {
        return dependencies.count
    }

    var instability: Double {
        let fanTotal = fanIn + fanOut
        precondition(fanTotal > 0, "fanIn + fanOut == 0")
        return Double(fanOut) / Double(fanTotal)
    }

    mutating func addDependency(_ entityID: EntityID, componentID: ComponentID?, name: String?) {
        guard nil == dependencies[entityID] else { return }
        dependencies[entityID] = (componentID, name)
    }

    mutating func addDependent(_ componentID: ComponentID, entityID: EntityID) {
        guard !dependents.contains(where: { $0.0 == componentID && $0.1 == entityID }) else { return }
        dependents.append((componentID, entityID))
    }
}
