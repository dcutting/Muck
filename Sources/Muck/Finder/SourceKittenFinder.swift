import Foundation
import SourceKittenFramework

enum SourceKittenFinderError: Error {
    case path(String)
    case build(name: String)
}

class SourceKittenFinder: Finder {

    private let rootPath: String
    private let xcodeBuildArguments: [String]
    private let moduleNames: [String]
    private let isVerbose: Bool

    init(path: String, xcodeBuildArguments: [String], moduleNames: [String], isVerbose: Bool) {
        self.rootPath = path
        self.xcodeBuildArguments = xcodeBuildArguments
        self.moduleNames = moduleNames
        self.isVerbose = isVerbose
    }

    func find() throws -> [Declaration] {
        return try analyse(path: rootPath, xcodeBuildArguments: xcodeBuildArguments, moduleNames: moduleNames)
    }

    private func analyse(path: String, xcodeBuildArguments: [String], moduleNames: [String]) throws -> [Declaration] {
        return try moduleNames.map { moduleName in
            try analyse(path: path, xcodeBuildArguments: xcodeBuildArguments, moduleName: moduleName)
        }.flattened()
    }

    private func analyse(path: String, xcodeBuildArguments: [String], moduleName: String) throws -> [Declaration] {

        guard FileManager.default.fileExists(atPath: path) else {
            throw SourceKittenFinderError.path(path)
        }
        guard let module = Module(xcodeBuildArguments: xcodeBuildArguments, name: moduleName, inPath: path) else {
            throw SourceKittenFinderError.build(name: moduleName)
        }

        log("Analysing module \(module.name)")
        let sourceFiles = try module.sourceFiles.map { file -> Declaration in
            log("  - \(file)")
            return try makeFileDeclaration(for: file, module: module.name, arguments: module.compilerArguments)
        }
        return sourceFiles
    }

    private func makeFileDeclaration(for path: String, module: String, arguments: [String]) throws -> Declaration {
        let sourceKitOutput = try Request.index(file: path, arguments: arguments).send()
        let sourceKitEntities = findSourceKitEntities(in: sourceKitOutput)
        let (declarations, references) = extractDeclarationsAndReferences(from: sourceKitEntities, path: path, module: module)
        let name = path.strip(prefix: rootPath, suffix: ".swift")
        return Declaration(kind: .file, path: path, module: module, name: name, isAbstract: false, declarations: declarations, references: references)
    }

    private func findSourceKitEntities(in sourceKitOutput: [String: SourceKitRepresentable]) -> [[String: SourceKitRepresentable]] {
        guard let keyEntities = sourceKitOutput["key.entities"] as? [SourceKitRepresentable] else { return [] }
        return keyEntities.compactMap { $0 as? [String: SourceKitRepresentable] }
    }

    private func extractDeclarationsAndReferences(from sourceKitEntities: [[String: SourceKitRepresentable]], path: String, module: String, accumulatedNames: [String] = []) -> ([Declaration], [DeclarationID]) {

        var declarations = [Declaration]()
        var references = [DeclarationID]()

        for sourceKitEntity in sourceKitEntities {

            guard
                let name = sourceKitEntity["key.name"] as? String,
                let usr = sourceKitEntity["key.usr"] as? String,
                let kind = sourceKitEntity["key.kind"] as? String
                else { continue }

            let updatedAccumulatedNames = accumulatedNames + [name]

            let isDeclaration = kind.contains(".decl.")

            if isDeclaration {

                let subSourceKitEntities = findSourceKitEntities(in: sourceKitEntity)
                let (subDeclarations, subReferences) = extractDeclarationsAndReferences(from: subSourceKitEntities, path: path, module: module, accumulatedNames: updatedAccumulatedNames)

                if isNonLocal(kind: kind) {
                    let isAbstract = kind.contains(".protocol")
                    let declarationKind = DeclarationKind.declaration(usr)
                    let compoundName = updatedAccumulatedNames.joined(separator: ".")
                    let declaration = Declaration(kind: declarationKind, path: path, module: module, name: compoundName, isAbstract: isAbstract, declarations: subDeclarations, references: subReferences)
                    declarations.append(declaration)
                } else {
                    declarations.append(contentsOf: subDeclarations)
                    references.append(contentsOf: subReferences)
                }
            } else {
                if isNonLocal(kind: kind) {
                    let reference = usr
                    references.append(reference)
                }
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

    private func log(_ message: String) {
        if isVerbose {
            printStdErr(message)
        }
    }
}
