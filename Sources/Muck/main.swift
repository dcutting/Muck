import Foundation
import Basic
import Utility

struct MuckArguments {
    var parsedWorkspace: String?
    var parsedProject: String?
    var parsedScheme: String?
    var parsedTarget: String?
    var parsedModules: [String]?
    var parsedByFolder: Bool?
    var parsedVerboseArg: Bool?
}

func parseArguments() throws -> (ArgumentParser, MuckArguments) {

    let parser = ArgumentParser(usage: "<options>", overview: "A dependency analyser for Swift projects")
    let workspaceArg: OptionArgument<String> = parser.add(option: "--workspace", shortName: "-w", kind: String.self, usage: "The Xcode workspace (specify either workspace or project but not both)")
    let projectArg: OptionArgument<String> = parser.add(option: "--project", shortName: "-p", kind: String.self, usage: "The Xcode project (specify either workspace or project but not both)")
    let schemeArg: OptionArgument<String> = parser.add(option: "--scheme", shortName: "-s", kind: String.self, usage: "The Xcode scheme (required if workspace is specified)")
    let targetArg: OptionArgument<String> = parser.add(option: "--target", shortName: "-t", kind: String.self, usage: "The Xcode target (required if project is specified)")
    let modulesArg: OptionArgument<[String]> = parser.add(option: "--modules", shortName: "-m", kind: [String].self, usage: "The modules to analyse (required)")
    let byFolderArg: OptionArgument<Bool> = parser.add(option: "--byFolder", shortName: "-f", kind: Bool.self, usage: "Treat folders as components (by default, modules are treated as components)")
    let verboseArg: OptionArgument<Bool> = parser.add(option: "--verbose", shortName: "-v", kind: Bool.self, usage: "Verbose logging")

    let arguments = Array(ProcessInfo.processInfo.arguments.dropFirst())
    let parsedArguments = try parser.parse(arguments)

    var muckArguments = MuckArguments()
    muckArguments.parsedWorkspace = parsedArguments.get(workspaceArg)
    muckArguments.parsedProject = parsedArguments.get(projectArg)
    muckArguments.parsedScheme = parsedArguments.get(schemeArg)
    muckArguments.parsedTarget = parsedArguments.get(targetArg)
    muckArguments.parsedModules = parsedArguments.get(modulesArg)
    muckArguments.parsedByFolder = parsedArguments.get(byFolderArg)
    muckArguments.parsedVerboseArg = parsedArguments.get(verboseArg)

    return (parser, muckArguments)
}

func start(path: String, xcodeBuildArguments: [String], moduleNames: [String], granularityStrategy: GranularityStrategy, componentNameStrategy: ComponentNameStrategy, isVerbose: Bool) {

    let finder = SourceKittenFinder(path: path, xcodeBuildArguments: xcodeBuildArguments, moduleNames: moduleNames, isVerbose: isVerbose)
    let transformer = Transformer(granularityStrategy: granularityStrategy, componentNameStrategy: componentNameStrategy)

    do {
        let files = try finder.find()
        let components = transformer.transform(files: files)

        let mainSequence = MainSequence(components: components)

        let reporter = CompoundReporter(reporters: [
            DeclarationReporter(),
            DependencyReporter(componentNameStrategy: componentNameStrategy),
            ComponentCleanlinessReporter(sortBy: .distance),
            OverallCleanlinessReporter()
            ])
        print(reporter.makeReport(for: mainSequence))
    } catch SourceKittenFinderError.build(let name) {
        printStdErr("Could not build project for workspace/scheme or project/target, or could not find module \(name)")
    } catch {
        printStdErr(error.localizedDescription)
    }
}

enum MuckArgumentsError: Error {
    case needWorkspaceOrProject
    case workspaceAndProjectSpecified
    case noModulesSpecified
}

func main(muckArguments: MuckArguments) throws {

    guard let moduleNames = muckArguments.parsedModules else {
        throw MuckArgumentsError.noModulesSpecified
    }

    var hasWorkspace = false
    var hasScheme = false
    var hasProject = false
    var hasTarget = false
    var path = ""
    let byFolder = muckArguments.parsedByFolder ?? false
    let granularityStrategy: GranularityStrategy = byFolder ? FolderGranularityStrategy() : ModuleGranularityStrategy()
    var xcodeBuildArguments = [String]()
    if let workspace = muckArguments.parsedWorkspace {
        xcodeBuildArguments.append(contentsOf: ["-workspace", workspace])
        let workspacePath = URL(fileURLWithPath: workspace)
        path = workspacePath.deletingLastPathComponent().path
        hasWorkspace = true
    }
    if let scheme = muckArguments.parsedScheme {
        xcodeBuildArguments.append(contentsOf: ["-scheme", scheme])
        hasScheme = true
    }
    if let project = muckArguments.parsedProject {
        xcodeBuildArguments.append(contentsOf: ["-project", project])
        let projectPath = URL(fileURLWithPath: project)
        path = projectPath.deletingLastPathComponent().path
        hasProject = true
    }
    if let target = muckArguments.parsedTarget {
        xcodeBuildArguments.append(contentsOf: ["-target", target])
        hasTarget = true
    }
    let componentNameStrategy: ComponentNameStrategy = byFolder ? FilePathComponentNameStrategy(rootPath: path + "/") : ModuleComponentNameStrategy()

    let isVerbose = muckArguments.parsedVerboseArg ?? false

    if isVerbose {
        printStdErr(path)
        printStdErr(xcodeBuildArguments.description)
        printStdErr(moduleNames.description)
        printStdErr(granularityStrategy.description)
    }

    guard !(hasWorkspace && hasProject) else {
        throw MuckArgumentsError.workspaceAndProjectSpecified
    }
    guard (hasWorkspace && hasScheme) || (hasProject && hasTarget) else {
        throw MuckArgumentsError.needWorkspaceOrProject
    }

    start(path: path, xcodeBuildArguments: xcodeBuildArguments, moduleNames: moduleNames, granularityStrategy: granularityStrategy, componentNameStrategy: componentNameStrategy, isVerbose: isVerbose)
}

private func exitWithUsage(argumentParser: ArgumentParser) -> Never {
    argumentParser.printUsage(on: stderrStream)
    exit(1)
}

do {
    let (_, muckArguments) = try parseArguments()
    try main(muckArguments: muckArguments)
}
catch let error as ArgumentParserError {
    printStdErr(error.description)
}
catch let error {
    printStdErr(error.localizedDescription)
}
