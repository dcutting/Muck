import Foundation

class Transformer {

    enum ComponentGranularity {
        case module
        case folder
    }
    private let granularity: ComponentGranularity

    private var components = [ComponentID: Component]()
    private var declarations = [EntityID: ComponentID]()

    init(granularity: ComponentGranularity) {
        self.granularity = granularity
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
            component.abstractness.addAbstract()
        } else {
            component.abstractness.addConcrete()
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

                var srcComponent = findComponent(for: srcComponentID)
                srcComponent.stability.addDependency(entityID)
                components[srcComponentID] = srcComponent

                if let dst = dstComponentID {
                    var dstComponent = findComponent(for: dst)
                    dstComponent.stability.addDependent(srcComponentID, entityID: entityID)
                    components[dst] = dstComponent
                } // else external declaration
            }
        }
    }

    private func findComponentID(for file: SourceFile) -> String {
        switch granularity {
        case .module:
            return file.module
        case .folder:
            let url = URL(fileURLWithPath: file.path)
            return url.deletingLastPathComponent().relativePath
        }
    }

    private func findComponent(for componentID: ComponentID) -> Component {
        return components[componentID, default:
            Component(name: componentID, stability: Stability(), abstractness: Abstractness())]
    }
}
