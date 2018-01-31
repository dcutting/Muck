class DeclarationReporter: Reporter {

    var name: String {
        return "Declarations"
    }

    func makeReport(for mainSequence: MainSequence, declarations: [Declaration]) -> String {

        let components = mainSequence.components.map { component -> [String] in
            let abstracts = component.declarations.abstracts.sorted().map { abstract in
                "  - [A] \(declarations.findName(for: abstract))"
            }
            let concretes = component.declarations.concretes.sorted().map { concrete in
                "  - \(declarations.findName(for: concrete))"
            }
            return ["\(component.name)"] + abstracts + concretes
        }
        return components.flattened().joined(separator: "\n")
    }
}
