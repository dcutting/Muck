import SourceKittenFramework

enum SourceKittenFinderError: Error {
    case build(name: String)
}

class SourceKittenFinder: SourceFileFinder {

    let kinds = [
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
        
        //            "source.lang.swift.decl.function.method.instance",
        //            "source.lang.swift.decl.function.method.static",
        //            "source.lang.swift.decl.function.subscript",
        //            "source.lang.swift.decl.function.constructor",
        //            "source.lang.swift.decl.function.destructor",
        //            "source.lang.swift.decl.function.accessor.getter",
        //            "source.lang.swift.decl.function.accessor.setter",
        //            "source.lang.swift.decl.var.instance",
        //            "source.lang.swift.decl.var.local",
        //            "source.lang.swift.decl.extension.struct",
        //            "source.lang.swift.decl.extension.class",
        //            "source.lang.swift.decl.extension.enum",
        //            "source.lang.swift.ref.function.method.instance",
        //            "source.lang.swift.ref.function.method.static",
        //            "source.lang.swift.ref.function.subscript",
        //            "source.lang.swift.ref.function.constructor",
        //            "source.lang.swift.ref.function.destructor",
        //            "source.lang.swift.ref.function.accessor.getter",
        //            "source.lang.swift.ref.function.accessor.setter",
        //            "source.lang.swift.ref.var.instance",
        //            "source.lang.swift.ref.var.local"
    ]

    private let path: String
    private let xcodeBuildArguments: [String]
    private let moduleNames: [String]

    init(path: String, xcodeBuildArguments: [String], moduleNames: [String]) {
        self.path = path
        self.xcodeBuildArguments = xcodeBuildArguments
        self.moduleNames = moduleNames
    }

    func find() throws -> [SourceFile] {
        return try analyse(path: path, xcodeBuildArguments: xcodeBuildArguments, moduleNames: moduleNames)
    }

    private func analyse(path: String, xcodeBuildArguments: [String], moduleNames: [String]) throws -> [SourceFile] {
        let sourceFiles = try moduleNames.map { moduleName in
            try analyse(path: path, xcodeBuildArguments: xcodeBuildArguments, moduleName: moduleName)
        }
        return sourceFiles.flattened()
    }

    private func analyse(path: String, xcodeBuildArguments: [String], moduleName: String) throws -> [SourceFile] {

        guard let module = Module(xcodeBuildArguments: xcodeBuildArguments, name: moduleName, inPath: path) else {
            throw SourceKittenFinderError.build(name: moduleName)
        }

        printStdErr("Analysing module \(module.name)")
        let source = module.sourceFiles
        let sourceFiles = source.map { file -> SourceFile? in
            printStdErr("  - \(file)")
            return makeSourceFile(for: file, module: module.name, arguments: module.compilerArguments)
        }
        return sourceFiles.flatMap { $0 }
    }

    private func makeSourceFile(for file: String, module: String, arguments: [String]) -> SourceFile? {
        let r: [String: SourceKitRepresentable] = Request.index(file: file, arguments: arguments).send()

        guard let (declarations, references) = extractEntities(dict: r) else { return nil }
        return SourceFile(path: file, module: module, declarations: declarations, references: references)
    }

    private func extractEntities(dict: [String: SourceKitRepresentable]) -> (declarations: [Entity], references: [Entity])? {

        guard let entities = dict["key.entities"] as? [SourceKitRepresentable] else { return nil }

        var declarations = [Entity]()
        var references = [Entity]()

        for rawEntity in entities {
            let e = rawEntity as! [String: SourceKitRepresentable]

            guard let kind = e["key.kind"] as? String else { continue }
            if kinds.contains(kind) {
                guard
                    let name = e["key.name"] as? String,
                    let usr = e["key.usr"] as? String
                    else { continue }
                let entity = Entity(name: name, kind: kind, usr: usr)
                if kind.contains(".decl.") {
                    declarations.append(entity)
                } else {
                    references.append(entity)
                }
            }
            if let (subDecls, subRefs) = extractEntities(dict: e) {
                declarations.append(contentsOf: subDecls)
                references.append(contentsOf: subRefs)
            }
        }

        return (declarations, references)
    }
}
