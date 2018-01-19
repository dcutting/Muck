import Foundation
import SourceKittenFramework

class SourceKittenFinder: Finder {

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

    func find() -> [SourceFile] {

        var sourceFiles = [SourceFile]()
        sourceFiles.append(contentsOf: gloop())
        sourceFiles.append(contentsOf: barbaloot())

        return sourceFiles
    }

    private func gloop() -> [SourceFile] {

        let modulePath = "/Users/dcutting/Dropbox/Dan/Code/Gloop"
        let moduleName = "Gloop"
        guard let module = Module(xcodeBuildArguments: [], name: moduleName, inPath: modulePath) else { preconditionFailure() }

        let schlopp = makeSourceFile(for: "/Users/dcutting/Dropbox/Dan/Code/Gloop/Gloop/Schlopp/Schlopp.swift", module: moduleName, arguments: module.compilerArguments)
        let thneed = makeSourceFile(for: "/Users/dcutting/Dropbox/Dan/Code/Gloop/Gloop/Schlopp/Thneed.swift", module: moduleName, arguments: module.compilerArguments)
        let thing = makeSourceFile(for: "/Users/dcutting/Dropbox/Dan/Code/Gloop/Gloop/Thing.swift", module: moduleName, arguments: module.compilerArguments)
        return [schlopp, thneed, thing].flatMap { $0 }
    }

    private func barbaloot() -> [SourceFile] {

        let modulePath = "/Users/dcutting/Dropbox/Dan/Code/Gloop"
        let moduleName = "Barbaloot"
        guard let module = Module(xcodeBuildArguments: [], name: moduleName, inPath: modulePath) else { preconditionFailure() }

        let sourceFile = makeSourceFile(for: "/Users/dcutting/Dropbox/Dan/Code/Gloop/Barbaloot/Bear.swift", module: moduleName, arguments: module.compilerArguments)
        return [sourceFile].flatMap { $0 }
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

//        print(toJSON(r))
    }
}
