struct Dependency: Hashable {

    let componentID: ComponentID?
    let declarationID: DeclarationID
}

struct References {

    private var dependents = Set<Dependency>()
    var dependencies = Set<Dependency>()

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

    mutating func addDependent(componentID: ComponentID, declarationID: DeclarationID) {
        let dependency = Dependency(componentID: componentID, declarationID: declarationID)
        dependents.insert(dependency)
    }

    mutating func addDependency(componentID: ComponentID?, declarationID: DeclarationID) {
        let dependency = Dependency(componentID: componentID, declarationID: declarationID)
        dependencies.insert(dependency)
    }
}
