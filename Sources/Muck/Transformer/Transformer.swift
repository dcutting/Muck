import Foundation

class Transformer {

    private let granularityStrategy: GranularityStrategy
    private let componentNameStrategy: ComponentNameStrategy
    private let shouldIgnoreExternalDependencies: Bool

    private var declarationIndex = [DeclarationID: ComponentID]()
    private var components = [ComponentID: Component]()

    init(granularityStrategy: GranularityStrategy, componentNameStrategy: ComponentNameStrategy, shouldIgnoreExternalDependencies: Bool) {
        self.granularityStrategy = granularityStrategy
        self.componentNameStrategy = componentNameStrategy
        self.shouldIgnoreExternalDependencies = shouldIgnoreExternalDependencies
    }

    func transform(declarations: [Declaration]) -> [Component] {
        reset()
        declarations.forEach(index)
        declarations.forEach(analyseAbstractness)
        declarations.forEach(analyseStability)
        return Array(components.values)
    }

    private func reset() {
        components.removeAll()
        declarationIndex.removeAll()
    }

    private func index(declaration: Declaration) {
        declaration.declarations.forEach(index)
        guard case .declaration(let declarationID) = declaration.kind else { return }
        let componentID = granularityStrategy.findComponentID(for: declaration)
        declarationIndex[declarationID] = componentID
    }

    private func analyseAbstractness(declaration: Declaration) {
        declaration.declarations.forEach(analyseAbstractness)
        guard case .declaration(let declarationID) = declaration.kind else { return }
        var component = findComponent(for: declaration)
        if declaration.isAbstract {
            component.types.addAbstract(declarationID)
        } else {
            component.types.addConcrete(declarationID)
        }
        components[component.componentID] = component
    }

    private func analyseStability(for declaration: Declaration) {
        analyseStability(for: declaration, parent: nil)
    }

    private func analyseStability(for declaration: Declaration, parent: DeclarationID?) {

        let thisComponentID = granularityStrategy.findComponentID(for: declaration)

        if let parent = parent, case .declaration(let declarationID) = declaration.kind {

            if nil != components[parent] {
                addDependency(componentID: parent, declarationID: declarationID, ownedBy: thisComponentID)
            }
        }

        for dependencyID in declaration.references {

            let referencedComponentID = declarationIndex[dependencyID]

            guard thisComponentID != referencedComponentID else { continue }

            addDependent(componentID: referencedComponentID, declarationID: dependencyID, from: thisComponentID)
            addDependency(componentID: thisComponentID, declarationID: dependencyID, ownedBy: referencedComponentID)
        }

        if case .declaration(let declarationID) = declaration.kind {
            declaration.declarations.forEach {
                analyseStability(for: $0, parent: declarationID)
            }
        } else {
            declaration.declarations.forEach(analyseStability)
        }
    }

    private func addDependent(componentID: ComponentID?, declarationID: DeclarationID, from thisComponentID: ComponentID) {
        guard let referencedID = componentID else { return } // external declaration
        var referencedComponent = findComponent(forID: referencedID)
        referencedComponent.references.addDependent(componentID: referencedID, declarationID: declarationID)
        components[referencedID] = referencedComponent
    }

    private func addDependency(componentID: ComponentID, declarationID: DeclarationID, ownedBy referencedComponentID: ComponentID?) {
        if referencedComponentID == nil && shouldIgnoreExternalDependencies { return }
        var thisComponent = findComponent(forID: componentID)
        thisComponent.references.addDependency(componentID: referencedComponentID, declarationID: declarationID)
        components[componentID] = thisComponent
    }

    private func findComponent(for declaration: Declaration) -> Component {
        let componentID = granularityStrategy.findComponentID(for: declaration)
        return findComponent(forID: componentID)
    }

    private func findComponent(forID componentID: ComponentID) -> Component {
        return components[componentID, default: makeComponent(withID: componentID)]
    }

    private func makeComponent(withID componentID: ComponentID) -> Component {
        let name = componentNameStrategy.findComponentName(for: componentID)
        return Component(componentID: componentID, name: name, types: Types(), references: References())
    }
}
