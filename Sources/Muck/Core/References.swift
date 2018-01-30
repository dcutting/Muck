private struct Dependency: Hashable {

    let dependentComponentID: ComponentID
    let dependency: DeclarationID

    var hashValue: Int {
        return dependentComponentID.hashValue ^ dependency.hashValue
    }

    static func ==(lhs: Dependency, rhs: Dependency) -> Bool {
        return lhs.dependentComponentID == rhs.dependentComponentID && lhs.dependency == rhs.dependency
    }
}

struct References {

    private var dependents = [Dependency: DeclarationID]()
    var dependencies = [DeclarationID: ComponentID?]()

    var fanIn: Int {
        return dependents.count
    }

    var fanOut: Int {
        return dependencies.count
    }

    var instability: Double {
        let fanTotal = fanIn + fanOut
        guard fanTotal > 0 else { return 0.0 }
        return Double(fanOut) / Double(fanTotal)
    }

    mutating func addDependency(on entityID: DeclarationID, ownedBy componentID: ComponentID?) {
        dependencies[entityID] = componentID
    }

    mutating func addDependency(on entityID: DeclarationID, from componentID: ComponentID) {
        let dependency = Dependency(dependentComponentID: componentID, dependency: entityID)
        dependents[dependency] = entityID
    }
}
