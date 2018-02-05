class DeclarationReporter: Reporter {

    var name: String {
        return "Declarations"
    }

    func makeReport(for mainSequence: MainSequence) -> String {

        let components = mainSequence.components.sorted { $0.name < $1.name }
        let componentReport = components.map { component -> [String] in
            let abstracts = component.types.abstracts.map { abstract in
                mainSequence.declarations.findName(for: abstract)
            }.sorted().map {
                "  - [A] \($0)"
            }
            let concretes = component.types.concretes.map { concrete in
                mainSequence.declarations.findName(for: concrete)
            }.sorted().map {
                "  - \($0)"
            }
            return ["\(component.name)"] + abstracts + concretes
        }
        return componentReport.flattened().joined(separator: "\n")
    }
}
