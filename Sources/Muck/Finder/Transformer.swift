import Foundation

class Transformer {

    var components = [String: Component]()

    var decls = [String: String]()

    var fanOuts = [String: Set<String>]()

    func transform(sourceFiles: [SourceFile]) -> [Component] {

        partitionDeclarations(from: sourceFiles)
        tallyReferences(for: sourceFiles)

        print(components)
        return Array(components.values)
    }

    private func partitionDeclarations(from sourceFiles: [SourceFile]) {

        for file in sourceFiles {
            print(file)
            let componentID = findComponentID(for: file)
            for decl in file.declarations {
                decls[decl.usr] = componentID
                var component = findComponent(for: componentID)
                if decl.kind.contains(".protocol") {    // todo should we include non-public things
                    component.abstractness.addAbstract()
                } else {
                    component.abstractness.addNonAbstract()
                }
                components[componentID] = component
            }
        }
    }

    private func findComponentID(for file: SourceFile) -> String {
        let url = URL(fileURLWithPath: file.path)
        return url.deletingLastPathComponent().absoluteString
//        return file.module
    }

    private func tallyReferences(for sourceFiles: [SourceFile]) {

        for file in sourceFiles {
            for ref in file.references {
                let srcComponentID = findComponentID(for: file)
                let dstComponentID = decls[ref.usr]

                guard srcComponentID != dstComponentID else { continue }

                var outs = findFanOuts(for: srcComponentID)
                guard !outs.contains(ref.usr) else { continue }

                outs.insert(ref.usr)
                var srcComponent = findComponent(for: srcComponentID)
                fanOuts[srcComponentID] = outs
                srcComponent.stability.addFanOut()  // todo don't count same ref twice
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
