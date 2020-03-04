private struct Edge: Hashable {

    let src: ComponentID
    let dst: ComponentID?
}

class DotDependencyReporter: Reporter {

    var name: String {
        return "Dot Dependencies"
    }

    func makeReport(for mainSequence: MainSequence) -> String {

        let components = mainSequence.components.sorted { $0.name < $1.name }
        let componentEdges = components.map { component -> [String] in

            let edges = component.references.dependencies.reduce(Set<Edge>()) { acc, dependency in
                let edge = Edge(src: component.componentID, dst: dependency.componentID)
                return acc.union([edge])
            }

            let dotEdges = edges.map { edge -> String in
                let srcName = findName(for: edge.src, in: mainSequence)
                let dstName = findName(for: edge.dst, in: mainSequence)
                return "  \"\(srcName)\" -> \"\(dstName)\""
            }
            return dotEdges
        }
        let result = ["digraph {"] + componentEdges.flattened() + ["}"]
        return result.joined(separator: "\n")
    }

    private func findName(for componentID: ComponentID?, in mainSequence: MainSequence) -> String {
        let component = mainSequence.components.first { $0.componentID == componentID }
        return component?.name ?? "<extern>"
    }
}
