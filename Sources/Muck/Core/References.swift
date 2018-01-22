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
    var dependencies = [EntityID: (ComponentID?, Entity)]()

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

    mutating func addDependency(on entity: Entity, ownedBy componentID: ComponentID?) {
        dependencies[entity.entityID] = (componentID, entity)
    }

    mutating func addDependency(on entity: Entity, from componentID: ComponentID) {
        let dependency = Dependency(dependentComponentID: componentID, dependency: entity.entityID)
        dependents[dependency] = entity
    }
}
