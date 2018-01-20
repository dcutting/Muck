import Foundation

class Transformer {

    enum ComponentGranularity {
        case module
        case folder
    }
    private let granularity: ComponentGranularity

    private var components = [ComponentID: Component]()
    private var declarations = [EntityID: ComponentID]()
    private var fanOuts = [ComponentID: Set<EntityID>]()

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
        fanOuts.removeAll()
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
                let dstComponentID = declarations[reference.usr]

                guard srcComponentID != dstComponentID else { continue }

                var outs = fanOuts[srcComponentID, default: Set<String>()]
                guard !outs.contains(reference.usr) else { continue }
                outs.insert(reference.usr)
                fanOuts[srcComponentID] = outs

                var srcComponent = findComponent(for: srcComponentID)
                srcComponent.stability.addFanOut()
                components[srcComponentID] = srcComponent

                if let dst = dstComponentID {
                    var dstComponent = findComponent(for: dst)
                    dstComponent.stability.addFanIn()
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
