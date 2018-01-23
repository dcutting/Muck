import Basic
import Foundation
import Utility

enum ArgumentsBuilderError: Error, LocalizedError {

    case needWorkspaceOrProject
    case workspaceAndProjectSpecified
    case missingScheme
    case missingTargetOrScheme
    case noModulesSpecified

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
        }
    }
}

class ArgumentsBuilder {

    private let parser = ArgumentParser(usage: "<options>", overview: "A dependency analyser for Swift projects")

    func parse(arguments: [String]) -> Raker.Arguments {

        do {
            let workspaceArg: OptionArgument<String> =
                parser.add(option: "--workspace", shortName: "-w", kind: String.self, usage: "The Xcode workspace (specify either workspace or project but not both)")
            let projectArg: OptionArgument<String> =
                parser.add(option: "--project", shortName: "-p", kind: String.self, usage: "The Xcode project (specify either workspace or project but not both)")
            let schemeArg: OptionArgument<String> =
                parser.add(option: "--scheme", shortName: "-s", kind: String.self, usage: "The Xcode scheme (required if workspace is specified)")
            let targetArg: OptionArgument<String> =
                parser.add(option: "--target", shortName: "-t", kind: String.self, usage: "The Xcode target (required if project is specified)")
            let modulesArg: OptionArgument<[String]> =
                parser.add(option: "--modules", shortName: "-m", kind: [String].self, usage: "The modules to analyse (required)")
            let byFolderArg: OptionArgument<Bool> =
                parser.add(option: "--byFolder", shortName: "-f", kind: Bool.self, usage: "Treat folders as components (by default, modules are treated as components)")
            let verboseArg: OptionArgument<Bool> =
                parser.add(option: "--verbose", shortName: "-v", kind: Bool.self, usage: "Verbose logging")

            let arguments = Array(arguments.dropFirst())
            let parsedArguments = try parser.parse(arguments)

            let (path, xcodeBuildArguments) = try parseBuildArguments(parsedArguments: parsedArguments,
                                                                      workspaceArg: workspaceArg,
                                                                      projectArg: projectArg,
                                                                      schemeArg: schemeArg,
                                                                      targetArg: targetArg)

            let byFolder = parsedArguments.get(byFolderArg) ?? false
            let granularityStrategy: GranularityStrategy = byFolder ? FolderGranularityStrategy() : ModuleGranularityStrategy()
            let componentNameStrategy: ComponentNameStrategy = byFolder ? FilePathComponentNameStrategy(rootPath: path + "/") : ModuleComponentNameStrategy()
            guard let moduleNames = parsedArguments.get(modulesArg) else {
                throw ArgumentsBuilderError.noModulesSpecified
            }

            let isVerbose = parsedArguments.get(verboseArg) ?? false

            let muckArguments = Raker.Arguments(path: path,
                                               xcodeBuildArguments: xcodeBuildArguments,
                                               moduleNames: moduleNames,
                                               isVerbose: isVerbose,
                                               granularityStrategy: granularityStrategy,
                                               componentNameStrategy: componentNameStrategy)

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

    private func parseBuildArguments(parsedArguments: ArgumentParser.Result,
                                     workspaceArg: OptionArgument<String>,
                                     projectArg: OptionArgument<String>,
                                     schemeArg: OptionArgument<String>,
                                     targetArg: OptionArgument<String>) throws -> (String, [String]) {

        var hasWorkspace = false
        var hasScheme = false
        var hasProject = false
        var hasTarget = false
        var path = ""
        var xcodeBuildArguments = [String]()

        let parsedWorkspace = parsedArguments.get(workspaceArg)
        let parsedProject = parsedArguments.get(projectArg)
        let parsedScheme = parsedArguments.get(schemeArg)
        let parsedTarget = parsedArguments.get(targetArg)

        if let workspace = parsedWorkspace {
            xcodeBuildArguments.append(contentsOf: ["-workspace", workspace])
            path = findPath(forWorkspaceOrProject: workspace)
            hasWorkspace = true
        }
        if let scheme = parsedScheme {
            xcodeBuildArguments.append(contentsOf: ["-scheme", scheme])
            hasScheme = true
        }
        if let project = parsedProject {
            xcodeBuildArguments.append(contentsOf: ["-project", project])
            path = findPath(forWorkspaceOrProject: project)
            hasProject = true
        }
        if let target = parsedTarget {
            xcodeBuildArguments.append(contentsOf: ["-target", target])
            hasTarget = true
        }

        if !(hasWorkspace || hasProject) {
            throw ArgumentsBuilderError.needWorkspaceOrProject
        }
        if hasWorkspace && hasProject {
            throw ArgumentsBuilderError.workspaceAndProjectSpecified
        }
        if hasWorkspace && !hasScheme {
            throw ArgumentsBuilderError.missingScheme
        }
        if hasProject && !(hasTarget || hasScheme) {
            throw ArgumentsBuilderError.missingTargetOrScheme
        }

        return (path, xcodeBuildArguments)
    }

    private func findPath(forWorkspaceOrProject workspaceOrProject: String) -> String {
        let path = URL(fileURLWithPath: workspaceOrProject)
        return path.deletingLastPathComponent().path
    }

    private func exitWithUsage() -> Never {
        parser.printUsage(on: stderrStream)
        exit(1)
    }
}
