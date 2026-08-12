import CryptoKit
import Foundation
import MuckCore

final class SourceKittenIndexCache {
    private static let schemaVersion = 1
    private static let cacheDirectoryEnvironmentVariable = "MUCK_CACHE_DIRECTORY"

    private struct CacheKey: Codable, Equatable {
        let schemaVersion: Int
        let projectPath: String
        let relativePath: String
        let module: String
        let sourceHash: String
        let compilerArgumentsHash: String
        let toolchainIdentifier: String
    }

    private struct CacheEntry: Codable {
        let key: CacheKey
        let declaration: Declaration
    }

    private let projectURL: URL
    private let cacheDirectoryURL: URL
    private let toolchainIdentifier: String

    init(projectURL: URL, cacheDirectoryURL: URL? = nil) {
        self.projectURL = Self.canonicalURL(projectURL)
        self.cacheDirectoryURL = cacheDirectoryURL ?? Self.defaultCacheDirectory()
        self.toolchainIdentifier = Self.currentToolchainIdentifier()
    }

    func declaration(
        for path: String,
        module: String,
        compilerArguments: [String],
        make: () throws -> Declaration
    ) throws -> Declaration {
        if let cached = load(for: path, module: module, compilerArguments: compilerArguments) {
            return cached
        }

        let declaration = try make()
        store(declaration, for: path, module: module, compilerArguments: compilerArguments)
        return declaration
    }

    func load(for path: String, module: String, compilerArguments: [String]) -> Declaration? {
        guard let key = makeKey(for: path, module: module, compilerArguments: compilerArguments) else {
            return nil
        }
        guard let fileURL = cacheURL(for: key),
              let data = try? Data(contentsOf: fileURL),
              let entry = try? JSONDecoder().decode(CacheEntry.self, from: data) else {
            return nil
        }
        guard entry.key == key else { return nil }
        return entry.declaration
    }

    func store(
        _ declaration: Declaration,
        for path: String,
        module: String,
        compilerArguments: [String]
    ) {
        guard let key = makeKey(for: path, module: module, compilerArguments: compilerArguments),
              let cacheURL = cacheURL(for: key) else {
            return
        }

        do {
            try FileManager.default.createDirectory(
                at: cacheDirectoryURL,
                withIntermediateDirectories: true)
            let entry = CacheEntry(key: key, declaration: declaration)
            let data = try JSONEncoder().encode(entry)
            try data.write(to: cacheURL, options: .atomic)
        } catch {
            // Caching is an optimization. An unwritable cache must not fail analysis.
        }
    }

    private func makeKey(for path: String, module: String, compilerArguments: [String]) -> CacheKey? {
        let fileURL = Self.canonicalURL(URL(fileURLWithPath: path, relativeTo: projectURL))
        guard let source = try? Data(contentsOf: fileURL),
              let arguments = try? JSONEncoder().encode(compilerArguments) else {
            return nil
        }

        return CacheKey(
            schemaVersion: Self.schemaVersion,
            projectPath: projectURL.path,
            relativePath: relativePath(for: fileURL),
            module: module,
            sourceHash: Self.hash(source),
            compilerArgumentsHash: Self.hash(arguments),
            toolchainIdentifier: toolchainIdentifier)
    }

    private func relativePath(for fileURL: URL) -> String {
        let rootPath = projectURL.path.hasSuffix("/") ? projectURL.path : projectURL.path + "/"
        guard fileURL.path.hasPrefix(rootPath) else {
            return fileURL.path
        }
        return String(fileURL.path.dropFirst(rootPath.count))
    }

    private func cacheURL(for key: CacheKey) -> URL? {
        let canonicalKey = [
            String(key.schemaVersion),
            key.projectPath,
            key.relativePath,
            key.module,
            key.sourceHash,
            key.compilerArgumentsHash,
            key.toolchainIdentifier
        ].joined(separator: "\u{0}")
        let data = Data(canonicalKey.utf8)
        return cacheDirectoryURL.appendingPathComponent(Self.hash(data) + ".json")
    }

    private static func defaultCacheDirectory() -> URL {
        if let path = ProcessInfo.processInfo.environment[cacheDirectoryEnvironmentVariable],
           !path.isEmpty {
            return URL(fileURLWithPath: path, isDirectory: true)
        }

        let baseURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
            ?? URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
        return baseURL.appendingPathComponent("Muck/Index", isDirectory: true)
    }

    private static func canonicalURL(_ url: URL) -> URL {
        return url.standardizedFileURL.resolvingSymlinksInPath()
    }

    private static func hash(_ data: Data) -> String {
        SHA256.hash(data: data).map { String(format: "%02x", $0) }.joined()
    }

    private static func currentToolchainIdentifier() -> String {
        let process = Process()
        let output = Pipe()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        process.arguments = ["swiftc", "--version"]
        process.standardOutput = output
        process.standardError = output

        do {
            try process.run()
            process.waitUntilExit()
            guard process.terminationStatus == 0 else { return "unknown" }
            return String(data: output.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8)
                ?? "unknown"
        } catch {
            return "unknown"
        }
    }
}
