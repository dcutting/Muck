import ArgumentParser
import Foundation
import MuckCore
import MuckSourceKit

enum ArgumentsBuilderError: Error, LocalizedError {
    case needWorkspaceOrProject
    case workspaceAndProjectSpecified
    case missingScheme
    case missingTargetOrScheme
    case missingPackage
    case noModulesSpecified
    case invalidGranularity(String)
    case unknownReport(String)

    var errorDescription: String? {
        switch self {
        case .needWorkspaceOrProject: return "No workspace or project specified"
        case .workspaceAndProjectSpecified: return "Specify only a workspace or project"
        case .missingScheme: return "Missing scheme"
        case .missingTargetOrScheme: return "Missing target or scheme"
        case .missingPackage: return "Package path does not contain Package.swift"
        case .noModulesSpecified: return "No modules specified for analysis"
        case .invalidGranularity(let name): return "Unknown granularity \(name)"
        case .unknownReport(let name): return "Unknown report \(name)"
        }
    }
}

public struct App: ParsableCommand {
    public static let configuration = CommandConfiguration(abstract: "A dependency analyser for Swift projects")

    @Option(name: [.customLong("workspace"), .customShort("w")], help: "The Xcode workspace")
    var workspace: String?
    @Option(name: [.customLong("package")], help: "The Swift package directory")
    var package: String?
    @Option(name: [.customLong("project"), .customShort("p")], help: "The Xcode project")
    var project: String?
    @Option(name: [.customLong("scheme"), .customShort("s")], help: "The Xcode scheme")
    var scheme: String?
    @Option(name: [.customLong("target"), .customShort("t")], help: "The Xcode target")
    var target: String?
    @Option(name: [.customLong("modules"), .customShort("m")], parsing: .upToNextOption, help: "The modules to analyse")
    var modules: [String] = []
    @Option(name: [.customLong("granularity"), .customShort("g")], help: "How to group components: type, file, folder, or module")
    var granularity: String?
    @Option(name: [.customLong("reports"), .customShort("r")], parsing: .upToNextOption, help: "Reports to produce")
    var reports: [String] = []
    @Flag(name: [.customLong("verbose"), .customShort("v")], help: "Verbose logging")
    var verbose = false
    @Flag(name: [.customLong("ignoreExterns"), .customShort("i")], help: "Ignore external dependencies")
    var ignoreExterns = false

    public init() {}

    public mutating func validate() throws {
        guard package != nil || workspace != nil || project != nil else { throw ValidationError("Specify --package, --workspace, or --project") }
        guard [package, workspace, project].compactMap({ $0 }).count == 1 else { throw ValidationError("Specify exactly one of --package, --workspace, or --project") }
        if let package {
            guard FileManager.default.fileExists(atPath: URL(fileURLWithPath: package).appendingPathComponent("Package.swift").path) else { throw ValidationError("Package path does not contain Package.swift") }
            guard scheme == nil && target == nil else { throw ValidationError("--scheme and --target cannot be used with --package") }
        }
        if workspace != nil && scheme == nil { throw ValidationError("--scheme is required with --workspace") }
        if project != nil && target == nil && scheme == nil { throw ValidationError("--target or --scheme is required with --project") }
        guard !modules.isEmpty else { throw ValidationError("At least one module is required") }
    }

    public func run() throws {
        let path: String
        let buildArguments: [String]
        let packagePath: String?
        if let package {
            path = URL(fileURLWithPath: package).standardizedFileURL.path
            buildArguments = []
            packagePath = path
        } else {
            (path, buildArguments) = try ProjectArgumentBuilder().parse(workspace: workspace, project: project, scheme: scheme, target: target)
            packagePath = nil
        }
        let (granularityStrategy, componentNameStrategy) = try GranularityArgumentBuilder().makeStrategies(granularity: granularity, path: path)
        let reporter = try ReporterArgumentBuilder().makeReporter(for: reports.isEmpty ? nil : reports)
        try Raker().start(arguments: Raker.Arguments(path: path, packagePath: packagePath, xcodeBuildArguments: buildArguments, moduleNames: modules, isVerbose: verbose, granularityStrategy: granularityStrategy, componentNameStrategy: componentNameStrategy, shouldIgnoreExternalDependencies: ignoreExterns, reporter: reporter))
    }
}
