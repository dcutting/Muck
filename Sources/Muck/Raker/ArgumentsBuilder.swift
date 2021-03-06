import Basic
import Foundation
import SPMUtility

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
        case .needWorkspaceOrProject:
            return "No workspace or project specified"
        case .workspaceAndProjectSpecified:
            return "Specify only a workspace or project"
        case .missingScheme:
            return "Missing scheme"
        case .missingTargetOrScheme:
            return "Missing target or scheme"
        case .noModulesSpecified:
            return "No modules specified for analysis"
        case .invalidGranularity(let name):
            return "Unknown granularity \(name)"
        case .unknownReport(let name):
            return "Unknown report \(name)"
        }
    }
}

class ArgumentsBuilder {

    private let parser = ArgumentParser(usage: "<options>", overview: "A dependency analyser for Swift projects")

    func parse(arguments: [String]) -> Raker.Arguments {

        let projectArgumentBuilder = ProjectArgumentBuilder()
        let granularityArgumentBuilder = GranularityArgumentBuilder()
        let reporterArgumentBuilder = ReporterArgumentBuilder()

        do {
            let workspaceArg: OptionArgument<String> =
                parser.add(option: "--workspace", shortName: "-w", kind: String.self, usage: "The Xcode workspace (specify either workspace or project but not both)")
            let projectArg: OptionArgument<String> =
                parser.add(option: "--project", shortName: "-p", kind: String.self, usage: "The Xcode project (specify either workspace or project but not both)")
            let schemeArg: OptionArgument<String> =
                parser.add(option: "--scheme", shortName: "-s", kind: String.self, usage: "The Xcode scheme (required if workspace is specified)")
            let targetArg: OptionArgument<String> =
                parser.add(option: "--target", shortName: "-t", kind: String.self, usage: "The Xcode target (permitted if project is specified)")
            let modulesArg: OptionArgument<[String]> =
                parser.add(option: "--modules", shortName: "-m", kind: [String].self, usage: "The modules to analyse (required)")
            let validGranularities = granularityArgumentBuilder.validGranularityNames.joined(separator: "|")
            let granularityArg: OptionArgument<String> =
                parser.add(option: "--granularity", shortName: "-g", kind: String.self, usage: "How to group components [\(validGranularities)] (defaults to module)")
            let verboseArg: OptionArgument<Bool> =
                parser.add(option: "--verbose", shortName: "-v", kind: Bool.self, usage: "Verbose logging")
            let ignoreExternsArg: OptionArgument<Bool> =
                parser.add(option: "--ignoreExterns", shortName: "-i", kind: Bool.self, usage: "Ignore dependencies external to specified modules")
            let validReports = reporterArgumentBuilder.validReportNames.joined(separator: "|")
            let reportsArg: OptionArgument<[String]> =
                parser.add(option: "--reports", shortName: "-r", kind: [String].self, usage: "One or more reports to produce on stdout [\(validReports)] (defaults to all)")

            let arguments = Array(arguments.dropFirst())
            let parsedArguments = try parser.parse(arguments)

            let parsedWorkspace = parsedArguments.get(workspaceArg)
            let parsedProject = parsedArguments.get(projectArg)
            let parsedScheme = parsedArguments.get(schemeArg)
            let parsedTarget = parsedArguments.get(targetArg)

            let (path, xcodeBuildArguments) = try projectArgumentBuilder.parse(workspace: parsedWorkspace,
                                                                               project: parsedProject,
                                                                               scheme: parsedScheme,
                                                                               target: parsedTarget)

            guard let moduleNames = parsedArguments.get(modulesArg) else {
                throw ArgumentsBuilderError.noModulesSpecified
            }

            let granularity = parsedArguments.get(granularityArg)
            let (granularityStrategy, componentNameStrategy) = try granularityArgumentBuilder.makeStrategies(granularity: granularity, path: path)

            let reportNames = parsedArguments.get(reportsArg)
            let reporter = try reporterArgumentBuilder.makeReporter(for: reportNames)

            let isVerbose = parsedArguments.get(verboseArg) ?? false
            let ignoreExternalDependencies = parsedArguments.get(ignoreExternsArg) ?? false

            let muckArguments = Raker.Arguments(path: path,
                                                xcodeBuildArguments: xcodeBuildArguments,
                                                moduleNames: moduleNames,
                                                isVerbose: isVerbose,
                                                granularityStrategy: granularityStrategy,
                                                componentNameStrategy: componentNameStrategy,
                                                shouldIgnoreExternalDependencies: ignoreExternalDependencies,
                                                reporter: reporter)

            if isVerbose {
                printStdErr("\(muckArguments)")
            }

            return muckArguments

        } catch let error as ArgumentParserError {
            printStdErr("Error: \(error.description)\n")
            exitWithUsage()
        } catch {
            printStdErr("Error: \(error.localizedDescription)\n")
            exitWithUsage()
        }
    }
    
    private func exitWithUsage() -> Never {
        parser.printUsage(on: stderrStream)
        exit(1)
    }
}
