import Foundation
import Testing
@testable import MuckCore
@testable import MuckSourceKit

struct SourceKittenIndexCacheTests {

    @Test
    func unchangedFileUsesCachedDeclaration() throws {
        let (projectURL, sourceURL) = try makeFixture()
        defer { try? FileManager.default.removeItem(at: projectURL) }

        let cacheURL = projectURL.appendingPathComponent("cache", isDirectory: true)
        let cache = SourceKittenIndexCache(projectURL: projectURL, cacheDirectoryURL: cacheURL)
        var sourceKitCalls = 0

        _ = try cache.declaration(for: sourceURL.path, module: "Example", compilerArguments: []) {
            sourceKitCalls += 1
            return makeDeclaration(path: sourceURL.path)
        }
        _ = try cache.declaration(for: sourceURL.path, module: "Example", compilerArguments: []) {
            sourceKitCalls += 1
            return makeDeclaration(path: sourceURL.path)
        }

        #expect(sourceKitCalls == 1)
    }

    @Test
    func changedSourceDoesNotUseCachedDeclaration() throws {
        let (projectURL, sourceURL) = try makeFixture()
        defer { try? FileManager.default.removeItem(at: projectURL) }

        let cacheURL = projectURL.appendingPathComponent("cache", isDirectory: true)
        let cache = SourceKittenIndexCache(projectURL: projectURL, cacheDirectoryURL: cacheURL)
        var sourceKitCalls = 0

        _ = try cache.declaration(for: sourceURL.path, module: "Example", compilerArguments: []) {
            sourceKitCalls += 1
            return makeDeclaration(path: sourceURL.path)
        }

        try Data("struct Changed {}\n".utf8).write(to: sourceURL)

        _ = try cache.declaration(for: sourceURL.path, module: "Example", compilerArguments: []) {
            sourceKitCalls += 1
            return makeDeclaration(path: sourceURL.path)
        }

        #expect(sourceKitCalls == 2)
    }

    @Test
    func movedFileReusesCachedDeclarationAndRebasesPaths() throws {
        let (projectURL, sourceURL) = try makeFixture()
        defer { try? FileManager.default.removeItem(at: projectURL) }

        let movedSourceURL = projectURL.appendingPathComponent("Other/MovedFile.swift")
        try FileManager.default.createDirectory(
            at: movedSourceURL.deletingLastPathComponent(),
            withIntermediateDirectories: true)
        try FileManager.default.moveItem(at: sourceURL, to: movedSourceURL)

        let cacheURL = projectURL.appendingPathComponent("cache", isDirectory: true)
        let cache = SourceKittenIndexCache(projectURL: projectURL, cacheDirectoryURL: cacheURL)
        var sourceKitCalls = 0

        try Data("struct SameContents {}\n".utf8).write(to: sourceURL)
        _ = try cache.declaration(for: sourceURL.path, module: "Example", compilerArguments: [sourceURL.path]) {
            sourceKitCalls += 1
            return makeDeclaration(path: sourceURL.path)
        }
        try FileManager.default.removeItem(at: sourceURL)
        _ = try cache.declaration(for: movedSourceURL.path, module: "Example", compilerArguments: [movedSourceURL.path]) {
            sourceKitCalls += 1
            return makeDeclaration(path: movedSourceURL.path)
        }

        let declaration = try #require(cache.load(
            for: movedSourceURL.path,
            module: "Example",
            compilerArguments: [movedSourceURL.path]))
        #expect(sourceKitCalls == 1)
        #expect(declaration.path == movedSourceURL.path)
        #expect(declaration.name == "Other/MovedFile")
        #expect(declaration.declarations.first?.path == movedSourceURL.path)
        #expect(declaration.declarations.first?.name == "SameContents")
    }

    @Test
    func changedCompilerArgumentsDoNotUseCachedDeclaration() throws {
        let (projectURL, sourceURL) = try makeFixture()
        defer { try? FileManager.default.removeItem(at: projectURL) }

        let cacheURL = projectURL.appendingPathComponent("cache", isDirectory: true)
        let cache = SourceKittenIndexCache(projectURL: projectURL, cacheDirectoryURL: cacheURL)
        var sourceKitCalls = 0

        _ = try cache.declaration(for: sourceURL.path, module: "Example", compilerArguments: ["-DOLD"]) {
            sourceKitCalls += 1
            return makeDeclaration(path: sourceURL.path)
        }
        _ = try cache.declaration(for: sourceURL.path, module: "Example", compilerArguments: ["-DNEW"]) {
            sourceKitCalls += 1
            return makeDeclaration(path: sourceURL.path)
        }

        #expect(sourceKitCalls == 2)
    }

    private func makeFixture() throws -> (URL, URL) {
        let projectURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("MuckIndexCache-\(UUID().uuidString)", isDirectory: true)
        let sourceURL = projectURL.appendingPathComponent("Sources/File.swift")
        try FileManager.default.createDirectory(
            at: sourceURL.deletingLastPathComponent(),
            withIntermediateDirectories: true)
        try Data("struct SameContents {}\n".utf8).write(to: sourceURL)
        return (projectURL, sourceURL)
    }

    private func makeDeclaration(path: String) -> Declaration {
        return Declaration(
            kind: .file,
            path: path,
            module: "Example",
            name: "Sources/File",
            isAbstract: false,
            declarations: [Declaration(
                kind: .declaration("example.usr"),
                path: path,
                module: "Example",
                name: "SameContents",
                isAbstract: false,
                declarations: [],
                references: [])],
            references: [])
    }
}
