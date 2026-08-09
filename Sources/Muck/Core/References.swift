public struct Dependency: Hashable {

    public let componentID: ComponentID?
    public let declarationID: DeclarationID
}

public struct References {

    private var dependents = Set<Dependency>()
    public var dependencies = Set<Dependency>()

    public var fanIn: Int {
        return dependents.count
    }

    public var fanOut: Int {
        return dependencies.count
    }

    public var instability: Double {
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
