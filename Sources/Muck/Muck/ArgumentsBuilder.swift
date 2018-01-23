import Basic
import Foundation
import Utility

enum ArgumentsBuilderError: Error {
    case needWorkspaceOrProject
    case workspaceAndProjectSpecified
    case noModulesSpecified
}

class ArgumentsBuilder {

    private let parser = ArgumentParser(usage: "<options>", overview: "A dependency analyser for Swift projects")

    func parse(arguments: [String]) -> Muck.Arguments {

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

            let parsedWorkspace = parsedArguments.get(workspaceArg)
            let parsedProject = parsedArguments.get(projectArg)
            let parsedScheme = parsedArguments.get(schemeArg)
            let parsedTarget = parsedArguments.get(targetArg)
            let parsedModules = parsedArguments.get(modulesArg)
            let parsedByFolder = parsedArguments.get(byFolderArg)
            let parsedVerboseArg = parsedArguments.get(verboseArg)

            guard let moduleNames = parsedModules else {
                throw ArgumentsBuilderError.noModulesSpecified
            }

            let isVerbose = parsedVerboseArg ?? false

            let byFolder = parsedByFolder ?? false
            let granularityStrategy: GranularityStrategy = byFolder ? FolderGranularityStrategy() : ModuleGranularityStrategy()

            var hasWorkspace = false
            var hasScheme = false
            var hasProject = false
            var hasTarget = false
            var path = ""
            var xcodeBuildArguments = [String]()

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
            let componentNameStrategy: ComponentNameStrategy = byFolder ? FilePathComponentNameStrategy(rootPath: path + "/") : ModuleComponentNameStrategy()

            if isVerbose {
                printStdErr(path)
                printStdErr(xcodeBuildArguments.description)
                printStdErr(moduleNames.description)
                printStdErr(granularityStrategy.description)
            }

            guard !(hasWorkspace && hasProject) else {
                throw ArgumentsBuilderError.workspaceAndProjectSpecified
            }
            guard (hasWorkspace && hasScheme) || (hasProject && hasTarget) else {
                throw ArgumentsBuilderError.needWorkspaceOrProject
            }

            return Muck.Arguments(path: path, xcodeBuildArguments: xcodeBuildArguments, moduleNames: moduleNames, isVerbose: isVerbose, granularityStrategy: granularityStrategy, componentNameStrategy: componentNameStrategy)

        } catch {
            printStdErr(error.localizedDescription)
            exitWithUsage()
        }
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
