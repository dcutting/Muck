import Foundation

enum ArgumentsBuilderError: Error, LocalizedError {
    case needWorkspaceOrProject
    case workspaceAndProjectSpecified
    case missingScheme
    case missingTargetOrScheme
    case noModulesSpecified
    case invalidGranularity(String)
    case unknownReport(String)

    var errorDescription: String? {
        switch self {
        case .needWorkspaceOrProject: return "No workspace or project specified"
        case .workspaceAndProjectSpecified: return "Specify only a workspace or project"
        case .missingScheme: return "Missing scheme"
        case .missingTargetOrScheme: return "Missing target or scheme"
        case .noModulesSpecified: return "No modules specified for analysis"
        case .invalidGranularity(let name): return "Unknown granularity \(name)"
        case .unknownReport(let name): return "Unknown report \(name)"
        }
    }
}

final class ArgumentsBuilder {
    private struct ParsedOptions {
        var values = [String: [String]]()
        var flags = Set<String>()

        func single(_ name: String) -> String? { values[name]?.first }
    }

    func parse(arguments: [String]) -> Raker.Arguments {
        let granularityBuilder = GranularityArgumentBuilder()
        let reporterBuilder = ReporterArgumentBuilder()
        do {
            let parsed = try parseOptions(Array(arguments.dropFirst()))
            let (path, buildArguments) = try ProjectArgumentBuilder().parse(
                workspace: parsed.single("workspace"), project: parsed.single("project"),
                scheme: parsed.single("scheme"), target: parsed.single("target"))
            guard let modules = parsed.values["modules"], !modules.isEmpty else {
                throw ArgumentsBuilderError.noModulesSpecified
            }
            let (granularity, naming) = try granularityBuilder.makeStrategies(
                granularity: parsed.single("granularity"), path: path)
            let reporter = try reporterBuilder.makeReporter(for: parsed.values["reports"])
            let result = Raker.Arguments(path: path, xcodeBuildArguments: buildArguments,
                moduleNames: modules, isVerbose: parsed.flags.contains("verbose"),
                granularityStrategy: granularity, componentNameStrategy: naming,
                shouldIgnoreExternalDependencies: parsed.flags.contains("ignoreExterns"),
                reporter: reporter)
            if result.isVerbose { printStdErr("\(result)") }
            return result
        } catch {
            printStdErr("Error: \(error.localizedDescription)")
            printUsage()
            Foundation.exit(1)
        }
    }

    private func parseOptions(_ arguments: [String]) throws -> ParsedOptions {
        let shortNames = ["w": "workspace", "p": "project", "s": "scheme", "t": "target",
                          "m": "modules", "g": "granularity", "v": "verbose",
                          "i": "ignoreExterns", "r": "reports"]
        let valueOptions = Set(["workspace", "project", "scheme", "target", "modules", "granularity", "reports"])
        var result = ParsedOptions()
        var index = 0
        while index < arguments.count {
            let raw = arguments[index]
            guard raw.hasPrefix("-") else { throw CLIError("Unexpected argument \(raw)") }
            let key = raw.hasPrefix("--") ? String(raw.dropFirst(2)) : shortNames[String(raw.dropFirst())]
            guard let key else { throw CLIError("Unknown option \(raw)") }
            if key == "help" { printUsage(); Foundation.exit(0) }
            if key == "verbose" || key == "ignoreExterns" {
                result.flags.insert(key); index += 1; continue
            }
            guard valueOptions.contains(key) else { throw CLIError("Unknown option \(raw)") }
            index += 1
            var values = [String]()
            while index < arguments.count && !arguments[index].hasPrefix("-") {
                values.append(arguments[index]); index += 1
            }
            guard !values.isEmpty else { throw CLIError("Missing value for \(raw)") }
            result.values[key, default: []].append(contentsOf: values)
        }
        return result
    }

    private struct CLIError: LocalizedError {
        let message: String
        init(_ message: String) { self.message = message }
        var errorDescription: String? { message }
    }

    private func printUsage() {
        printStdErr("""
        OVERVIEW: A dependency analyser for Swift projects
        USAGE: muck <options>
        OPTIONS: --workspace/-w --project/-p --scheme/-s --target/-t --modules/-m
                 --granularity/-g --reports/-r --verbose/-v --ignoreExterns/-i --help
        """)
    }
}
