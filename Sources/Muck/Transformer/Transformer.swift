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
        partitionDeclarations(for: files)
        tallyReferences(for: files)
        return Array(components.values)
    }

    private func partitionDeclarations(for files: [SourceFile]) {

        for file in files {
            let componentID = findComponentID(for: file)
            for declaration in file.declarations {
                declarations[declaration.usr] = componentID
                var component = findComponent(for: componentID)
                if declaration.kind.contains(".protocol") {    // todo should we include non-public things
                    component.abstractness.addAbstract()
                } else {
                    component.abstractness.addConcrete()
                }
                components[componentID] = component
            }
        }
    }

    private func findComponentID(for file: SourceFile) -> String {
        switch granularity {
        case .module:
            return file.module
        case .folder:
            let url = URL(fileURLWithPath: file.path)
            return url.deletingLastPathComponent().absoluteString
        }
    }

    private func tallyReferences(for sourceFiles: [SourceFile]) {

        for file in sourceFiles {
            for ref in file.references {
                let srcComponentID = findComponentID(for: file)
                let dstComponentID = declarations[ref.usr]

                guard srcComponentID != dstComponentID else { continue }

                var outs = findFanOuts(for: srcComponentID)
                guard !outs.contains(ref.usr) else { continue }

                outs.insert(ref.usr)
                var srcComponent = findComponent(for: srcComponentID)
                fanOuts[srcComponentID] = outs
                srcComponent.stability.addFanOut()
                components[srcComponentID] = srcComponent
                if let dst = dstComponentID {
                    var component = findComponent(for: dst)
                    component.stability.addFanIn()
                    components[dst] = component
                } else { // External declaration

                }
            }
        }
    }

    private func findFanOuts(for component: String) -> Set<String> {
        guard let out = fanOuts[component] else {
            let out = Set<String>()
            fanOuts[component] = out
            return out
        }
        return out
    }

    private func findComponent(for module: String) -> Component {
        guard let component = components[module] else {
            let component = Component(name: module, stability: Stability(), abstractness: Abstractness())
            components[module] = component
            return component
        }
        return component
    }
}
