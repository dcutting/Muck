struct Dependency: Hashable {

    let dependentComponentID: ComponentID
    let dependency: EntityID

    var hashValue: Int {
        return dependentComponentID.hashValue ^ dependency.hashValue
    }

    static func ==(lhs: Dependency, rhs: Dependency) -> Bool {
        return lhs.dependentComponentID == rhs.dependentComponentID && lhs.dependency == rhs.dependency
    }
}

struct References {

    var dependents = [Dependency: Entity]()
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

    mutating func addDependent(dependentComponentID: ComponentID, entity: Entity) {
        let dependency = Dependency(dependentComponentID: dependentComponentID, dependency: entity.entityID)
        dependents[dependency] = entity
    }
}
