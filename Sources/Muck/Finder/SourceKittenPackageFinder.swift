import Foundation
import MuckCore
import SourceKittenFramework

public final class SourceKittenPackageFinder: Finder {
    private let packageURL: URL
    private let moduleNames: [String]
    private let isVerbose: Bool

    public init(path: String, moduleNames: [String], isVerbose: Bool) {
        packageURL = URL(fileURLWithPath: path).standardizedFileURL
        self.moduleNames = moduleNames
        self.isVerbose = isVerbose
    }

    public func find() throws -> [Declaration] {
        guard FileManager.default.fileExists(atPath: packageURL.appendingPathComponent("Package.swift").path) else {
            throw SourceKittenFinderError.path(packageURL.path)
        }
        guard buildPackage() else {
            throw SourceKittenFinderError.packageBuild
        }

        return try moduleNames.map { moduleName in
            guard let module = Module(spmName: moduleName, inPath: packageURL.path) else {
                throw SourceKittenFinderError.build(name: moduleName)
            }
            log("Analysing Swift package module \(module.name)")
            return try module.sourceFiles.map { file in
                log("  - \(file)")
                let output = try Request.index(file: file, arguments: module.compilerArguments).send()
                let entities = findSourceKitEntities(in: output)
                let (declarations, references) = extractDeclarationsAndReferences(
                    from: entities, path: file, module: module.name)
                let name = URL(fileURLWithPath: file).standardizedFileURL.path
                    .strip(prefix: packageURL.path + "/", suffix: ".swift")
                return Declaration(kind: .file, path: file, module: module.name, name: name,
                                   isAbstract: false, declarations: declarations, references: references)
            }
        }.flattened()
    }

    private func buildPackage() -> Bool {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        process.arguments = ["swift", "build", "--build-system", "native"]
        process.currentDirectoryURL = packageURL
        process.standardOutput = FileHandle.standardError
        process.standardError = FileHandle.standardError
        do {
            try process.run()
            process.waitUntilExit()
            return process.terminationStatus == 0
        } catch {
            return false
        }
    }

    private func findSourceKitEntities(in output: [String: SourceKitRepresentable]) -> [[String: SourceKitRepresentable]] {
        guard let entities = output["key.entities"] as? [SourceKitRepresentable] else { return [] }
        return entities.compactMap { $0 as? [String: SourceKitRepresentable] }
    }

    private func extractDeclarationsAndReferences(
        from entities: [[String: SourceKitRepresentable]], path: String, module: String,
        accumulatedNames: [String] = []) -> ([Declaration], [DeclarationID]) {
        var declarations = [Declaration]()
        var references = [DeclarationID]()
        for entity in entities {
            guard let name = entity["key.name"] as? String,
                  let usr = entity["key.usr"] as? String,
                  let kind = entity["key.kind"] as? String else { continue }
            let names = accumulatedNames + [name]
            let children = findSourceKitEntities(in: entity)
            let (nestedDeclarations, nestedReferences) = extractDeclarationsAndReferences(
                from: children, path: path, module: module, accumulatedNames: names)
            if kind.contains(".decl.") {
                if isNonLocal(kind) {
                    declarations.append(Declaration(kind: .declaration(usr), path: path,
                        module: module, name: names.joined(separator: "."),
                        isAbstract: kind.contains(".protocol"), declarations: nestedDeclarations,
                        references: nestedReferences))
                } else {
                    declarations.append(contentsOf: nestedDeclarations)
                    references.append(contentsOf: nestedReferences)
                }
            } else if isNonLocal(kind) {
                references.append(usr)
            }
        }
        return (declarations, references)
    }

    private func isNonLocal(_ kind: String) -> Bool {
        kind.contains(".decl.class") || kind.contains(".decl.struct") ||
        kind.contains(".decl.enum") || kind.contains(".decl.protocol") ||
        kind.contains(".decl.actor") || kind.contains(".decl.macro") ||
        kind.contains(".decl.typealias") || kind.contains(".decl.function.free") ||
        kind.contains(".decl.function.operator") || kind.contains(".decl.var.global") ||
        kind.contains(".decl.var.static") || kind.contains(".ref.")
    }

    private func log(_ message: String) {
        if isVerbose { printStdErr(message) }
    }
}
