import SourceKittenFramework

enum SourceKittenFinderError: Error {
    case build(name: String)
}

class SourceKittenFinder: SourceFileFinder {

    private let path: String
    private let xcodeBuildArguments: [String]
    private let moduleNames: [String]
    private let isVerbose: Bool

    init(path: String, xcodeBuildArguments: [String], moduleNames: [String], isVerbose: Bool) {
        self.path = path
        self.xcodeBuildArguments = xcodeBuildArguments
        self.moduleNames = moduleNames
        self.isVerbose = isVerbose
    }

    func find() throws -> [SourceFile] {
        return try analyse(path: path, xcodeBuildArguments: xcodeBuildArguments, moduleNames: moduleNames)
    }

    private func analyse(path: String, xcodeBuildArguments: [String], moduleNames: [String]) throws -> [SourceFile] {
        return try moduleNames.map { moduleName in
            try analyse(path: path, xcodeBuildArguments: xcodeBuildArguments, moduleName: moduleName)
        }.flattened()
    }

    private func analyse(path: String, xcodeBuildArguments: [String], moduleName: String) throws -> [SourceFile] {

        guard let module = Module(xcodeBuildArguments: xcodeBuildArguments, name: moduleName, inPath: path) else {
            throw SourceKittenFinderError.build(name: moduleName)
        }

        log("Analysing module \(module.name)")
        let sourceFiles = module.sourceFiles.map { file -> SourceFile? in
            log("  - \(file)")
            return makeSourceFile(for: file, module: module.name, arguments: module.compilerArguments)
        }
        return sourceFiles.flatMap { $0 }
    }

    private func log(_ message: String) {
        if isVerbose {
            printStdErr(message)
        }
    }

    private func makeSourceFile(for file: String, module: String, arguments: [String]) -> SourceFile? {

        let request = Request.index(file: file, arguments: arguments).send()

        guard let entities = request["key.entities"] as? [SourceKitRepresentable] else { return nil }

        guard let (declarations, references) = extractEntities(from: entities) else { return nil }

        return SourceFile(path: file, module: module, declarations: declarations, references: references)
    }

    private func extractEntities(from entities: [SourceKitRepresentable]) -> (declarations: [Entity], references: [Entity])? {

        var declarations = [Entity]()
        var references = [Entity]()

        for rawEntity in entities {

            guard let entity = rawEntity as? [String: SourceKitRepresentable] else { continue }

            guard let kind = entity["key.kind"] as? String else { continue }

            if isNonLocal(kind: kind) {
                guard
                    let name = entity["key.name"] as? String,
                    let usr = entity["key.usr"] as? String
                    else { continue }
                let entity = Entity(name: name, kind: kind, usr: usr)
                if isDeclaration(kind) {
                    declarations.append(entity)
                } else {
                    references.append(entity)
                }
            }

            guard let subEntities = entity["key.entities"] as? [SourceKitRepresentable] else { continue }

            if let (subDeclarations, subReferences) = extractEntities(from: subEntities) {
                declarations.append(contentsOf: subDeclarations)
                references.append(contentsOf: subReferences)
            }
        }

        return (declarations, references)
    }

    private func isNonLocal(kind: String) -> Bool {

        let nonLocalKinds = [
            "source.lang.swift.decl.function.free",
            "source.lang.swift.decl.function.operator",
            "source.lang.swift.decl.class",
            "source.lang.swift.decl.struct",
            "source.lang.swift.decl.enum",
            "source.lang.swift.decl.enumelement",
            "source.lang.swift.decl.protocol",
            "source.lang.swift.decl.typealias",
            "source.lang.swift.decl.var.global",
            "source.lang.swift.decl.var.static",
            "source.lang.swift.ref.function.free",
            "source.lang.swift.ref.function.operator",
            "source.lang.swift.ref.class",
            "source.lang.swift.ref.struct",
            "source.lang.swift.ref.enum",
            "source.lang.swift.ref.enumelement",
            "source.lang.swift.ref.protocol",
            "source.lang.swift.ref.typealias",
            "source.lang.swift.ref.var.global",
            "source.lang.swift.ref.var.static",

            //"source.lang.swift.decl.function.method.instance",
            //"source.lang.swift.decl.function.method.static",
            //"source.lang.swift.decl.function.subscript",
            //"source.lang.swift.decl.function.constructor",
            //"source.lang.swift.decl.function.destructor",
            //"source.lang.swift.decl.function.accessor.getter",
            //"source.lang.swift.decl.function.accessor.setter",
            //"source.lang.swift.decl.var.instance",
            //"source.lang.swift.decl.var.local",
            //"source.lang.swift.decl.extension.struct",
            //"source.lang.swift.decl.extension.class",
            //"source.lang.swift.decl.extension.enum",
            //"source.lang.swift.ref.function.method.instance",
            //"source.lang.swift.ref.function.method.static",
            //"source.lang.swift.ref.function.subscript",
            //"source.lang.swift.ref.function.constructor",
            //"source.lang.swift.ref.function.destructor",
            //"source.lang.swift.ref.function.accessor.getter",
            //"source.lang.swift.ref.function.accessor.setter",
            //"source.lang.swift.ref.var.instance",
            //"source.lang.swift.ref.var.local"
        ]

        return nonLocalKinds.contains(kind)
    }

    private func isDeclaration(_ kind: String) -> Bool {
        return kind.contains(".decl.")
    }
}
