class DeclarationReporter: Reporter {

    var name: String {
        return "Declarations"
    }

    func makeReport(for mainSequence: MainSequence) -> String {

        let components = mainSequence.components.map { component -> [String] in
            let abstracts = component.types.abstracts.sorted().map { abstract in
                "  - [A] \(mainSequence.declarations.findName(for: abstract))"
            }
            let concretes = component.types.concretes.sorted().map { concrete in
                "  - \(mainSequence.declarations.findName(for: concrete))"
            }
            return ["\(component.name)"] + abstracts + concretes
        }
        return components.flattened().joined(separator: "\n")
    }
}
