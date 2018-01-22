class DeclarationReporter: Reporter {

    func makeReport(for mainSequence: MainSequence) -> String {

        let components = mainSequence.components.map { component -> [String] in
            let abstracts = component.abstractness.abstracts.map { abstract in
                "  - [A] \(abstract)"
            }
            let concretes = component.abstractness.concretes.map { concrete in
                "  - \(concrete)"
            }
            return ["\(component.name)"] + abstracts + concretes
        }
        return Array(components.joined()).joined(separator: "\n")
    }
}
