import Foundation

class Transformer {

    private let granularityStrategy: GranularityStrategy
    private let componentNameStrategy: ComponentNameStrategy

    private var components = [ComponentID: Component]()
    private var declarations = [EntityID: ComponentID]()

    init(granularityStrategy: GranularityStrategy, componentNameStrategy: ComponentNameStrategy) {
        self.granularityStrategy = granularityStrategy
        self.componentNameStrategy = componentNameStrategy
    }

    func transform(files: [SourceFile]) -> [Component] {
        reset()
        registerDeclarations(for: files)
        analyseAbstractness(for: files)
        analyseStability(for: files)
        return Array(components.values)
    }

    private func reset() {
        components.removeAll()
        declarations.removeAll()
    }

    private func registerDeclarations(for files: [SourceFile]) {
        for file in files {
            let componentID = granularityStrategy.findComponentID(for: file)
            for declaration in file.declarations {
                declarations[declaration.entityID] = componentID
            }
        }
    }

    private func analyseAbstractness(for files: [SourceFile]) {
        for file in files {
            let componentID = granularityStrategy.findComponentID(for: file)
            for declaration in file.declarations {
                analyseAbstractness(for: declaration, componentID: componentID)
            }
        }
    }

    private func analyseAbstractness(for declaration: Entity, componentID: ComponentID) {
        var component = findComponent(forID: componentID)
        if declaration.isAbstract {
            component.declarations.addAbstract(declaration.name)
        } else {
            component.declarations.addConcrete(declaration.name)
        }
        components[componentID] = component
    }

    private func analyseStability(for files: [SourceFile]) {
        for file in files {
            analyseStability(for: file)
        }
    }

    private func analyseStability(for file: SourceFile) {

        let thisComponentID = granularityStrategy.findComponentID(for: file)

        for entity in file.references {

            let dependencyID = entity.entityID
            let referencedComponentID = declarations[dependencyID]

            guard thisComponentID != referencedComponentID else { continue }

            updateReferenced(componentID: referencedComponentID, withDependency: entity, from: thisComponentID)
            updateThis(componentID: thisComponentID, withDependency: entity, ownedBy: referencedComponentID)
        }
    }

    private func updateReferenced(componentID: ComponentID?, withDependency entity: Entity, from thisComponentID: ComponentID) {
        guard let referencedID = componentID else { return } // external declaration
        var referencedComponent = findComponent(forID: referencedID)
        referencedComponent.references.addDependency(on: entity, from: thisComponentID)
        components[referencedID] = referencedComponent
    }

    private func updateThis(componentID: ComponentID, withDependency entity: Entity, ownedBy referencedComponentID: ComponentID?) {
        var thisComponent = findComponent(forID: componentID)
        thisComponent.references.addDependency(on: entity, ownedBy: referencedComponentID)
        components[componentID] = thisComponent
    }

    private func findComponent(forID componentID: ComponentID) -> Component {
        return components[componentID, default: makeComponent(withID: componentID)]
    }

    private func makeComponent(withID componentID: ComponentID) -> Component {
        let name = componentNameStrategy.findComponentName(for: componentID)
        return Component(name: name, declarations: Declarations(), references: References())
    }
}
