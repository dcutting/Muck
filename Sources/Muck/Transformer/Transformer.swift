import Foundation

class Transformer {

    private let granularityStrategy: GranularityStrategy
    private let componentNameStrategy: ComponentNameStrategy
    private let shouldIgnoreExternalDependencies: Bool

    private var components = [ComponentID: Component]()
    private var declarationIndex = [DeclarationID: ComponentID]()

    init(granularityStrategy: GranularityStrategy, componentNameStrategy: ComponentNameStrategy, shouldIgnoreExternalDependencies: Bool) {
        self.granularityStrategy = granularityStrategy
        self.componentNameStrategy = componentNameStrategy
        self.shouldIgnoreExternalDependencies = shouldIgnoreExternalDependencies
    }

    func transform(files: [Declaration]) -> [Component] {
        reset()
        registerDeclarations(for: files)
        analyseAbstractness(for: files)
        analyseStability(for: files)
        return Array(components.values)
    }

    private func reset() {
        components.removeAll()
        declarationIndex.removeAll()
    }

    private func registerDeclarations(for declarations: [Declaration]) {
        for file in declarations {
            for declaration in file.declarations {
                guard case .declaration(let entityID) = declaration.kind else { continue }
                let componentID = granularityStrategy.findComponentID(for: declaration)
                declarationIndex[entityID] = componentID
            }
        }
    }

    private func analyseAbstractness(for files: [Declaration]) {
        for file in files {
            for declaration in file.declarations {
                let componentID = granularityStrategy.findComponentID(for: declaration)
                analyseAbstractness(for: declaration, componentID: componentID)
            }
        }
    }

    private func analyseAbstractness(for declaration: Declaration, componentID: ComponentID) {
        var component = findComponent(forID: componentID)
        if declaration.isAbstract {
            component.declarations.addAbstract(declaration.name)
        } else {
            component.declarations.addConcrete(declaration.name)
        }
        components[componentID] = component
    }

    private func analyseStability(for declarations: [Declaration]) {
        for declaration in declarations {
            analyseStability(for: declaration)
        }
    }

    private func analyseStability(for declaration: Declaration) {

        for declaration in declaration.declarations {

            let thisComponentID = granularityStrategy.findComponentID(for: declaration)

            for dependencyID in declaration.references {

                let referencedComponentID = declarationIndex[dependencyID]

                guard thisComponentID != referencedComponentID else { continue }

//                updateReferenced(componentID: referencedComponentID, withDependency: reference, from: thisComponentID)
//                updateThis(componentID: thisComponentID, withDependency: reference, ownedBy: referencedComponentID)
            }
        }
    }

//    private func updateReferenced(componentID: ComponentID?, withDependency entity: Entity, from thisComponentID: ComponentID) {
//        guard let referencedID = componentID else { return } // external declaration
//        var referencedComponent = findComponent(forID: referencedID)
//        referencedComponent.references.addDependency(on: entity, from: thisComponentID)
//        components[referencedID] = referencedComponent
//    }
//
//    private func updateThis(componentID: ComponentID, withDependency entity: Entity, ownedBy referencedComponentID: ComponentID?) {
//        if referencedComponentID == nil && shouldIgnoreExternalDependencies { return }
//        var thisComponent = findComponent(forID: componentID)
//        thisComponent.references.addDependency(on: entity, ownedBy: referencedComponentID)
//        components[componentID] = thisComponent
//    }

    private func findComponent(forID componentID: ComponentID) -> Component {
        return components[componentID, default: makeComponent(withID: componentID)]
    }

    private func makeComponent(withID componentID: ComponentID) -> Component {
        let name = componentNameStrategy.findComponentName(for: componentID)
        return Component(name: name, declarations: Declarations(), references: References())
    }
}
