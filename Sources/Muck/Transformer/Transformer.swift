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
            let componentID = findComponentID(for: file)
            for declaration in file.declarations {
                declarations[declaration.usr] = componentID
            }
        }
    }

    private func analyseAbstractness(for files: [SourceFile]) {
        for file in files {
            let componentID = findComponentID(for: file)
            for declaration in file.declarations {
                analyseAbstractness(for: declaration, componentID: componentID)
            }
        }
    }

    private func analyseAbstractness(for declaration: Entity, componentID: ComponentID) {
        var component = findComponent(for: componentID)
        if declaration.isAbstract {
            component.abstractness.addAbstract(declaration.name)
        } else {
            component.abstractness.addConcrete(declaration.name)
        }
        components[componentID] = component
    }

    private func analyseStability(for files: [SourceFile]) {

        for file in files {
            let srcComponentID = findComponentID(for: file)

            for reference in file.references {

                let entityID = reference.usr

                let dstComponentID = declarations[entityID]

                guard srcComponentID != dstComponentID else { continue }

                var dstComponent: Component?
                if let dst = dstComponentID {
                    dstComponent = findComponent(for: dst)
                    dstComponent?.stability.addDependent(srcComponentID, entityID: entityID)
                    components[dst] = dstComponent
                } // else external declaration

                var srcComponent = findComponent(for: srcComponentID)
                srcComponent.stability.addDependency(entityID, componentID: dstComponentID, name: reference.name)
                components[srcComponentID] = srcComponent
            }
        }
    }

    private func findComponentID(for file: SourceFile) -> ComponentID {
        return granularityStrategy.findComponentID(for: file)
    }

    private func findComponent(for componentID: ComponentID) -> Component {
        return components[componentID, default: makeComponent(for: componentID)]
    }

    private func makeComponent(for componentID: ComponentID) -> Component {
        let name = componentNameStrategy.makeComponentName(for: componentID)
        return Component(name: name, stability: Stability(), abstractness: Abstractness())
    }
}
