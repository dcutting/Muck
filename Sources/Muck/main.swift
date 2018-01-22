import Foundation
import Basic
import Utility

let arguments = Array(ProcessInfo.processInfo.arguments.dropFirst())
let parser = ArgumentParser(usage: "<options>", overview: "A dependency analyser for Swift projects")
let workspaceArg: OptionArgument<String> = parser.add(option: "--workspace", shortName: "-w", kind: String.self, usage: "The Xcode workspace (specify either workspace or project but not both)")
let projectArg: OptionArgument<String> = parser.add(option: "--project", shortName: "-p", kind: String.self, usage: "The Xcode project (specify either workspace or project but not both)")
let schemeArg: OptionArgument<String> = parser.add(option: "--scheme", shortName: "-s", kind: String.self, usage: "The Xcode scheme (required if workspace is specified)")
let targetArg: OptionArgument<String> = parser.add(option: "--target", shortName: "-t", kind: String.self, usage: "The Xcode target (required if project is specified)")
let modulesArg: OptionArgument<[String]> = parser.add(option: "--modules", shortName: "-m", kind: [String].self, usage: "The modules to analyse (required)")
let byFolderArg: OptionArgument<Bool> = parser.add(option: "--byFolder", shortName: "-f", kind: Bool.self, usage: "Treat folders as components (by default, modules are treated as components)")

var parsedModules: [String]?
var parsedByFolder: Bool?
var parsedWorkspace: String?
var parsedScheme: String?
var parsedProject: String?
var parsedTarget: String?
do {
    let parsedArguments = try parser.parse(arguments)
    parsedModules = parsedArguments.get(modulesArg)
    parsedByFolder = parsedArguments.get(byFolderArg)
    parsedWorkspace = parsedArguments.get(workspaceArg)
    parsedScheme = parsedArguments.get(schemeArg)
    parsedProject = parsedArguments.get(projectArg)
    parsedTarget = parsedArguments.get(targetArg)
}
catch let error as ArgumentParserError {
    printStdErr(error.description)
}
catch let error {
    printStdErr(error.localizedDescription)
}

func start(path: String, xcodeBuildArguments: [String], moduleNames: [String], granularityStrategy: GranularityStrategy, componentNameStrategy: ComponentNameStrategy) {

    let finder = SourceKittenFinder(path: path, xcodeBuildArguments: xcodeBuildArguments, moduleNames: moduleNames)
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

if let moduleNames = parsedModules {
    var hasWorkspace = false
    var hasScheme = false
    var hasProject = false
    var hasTarget = false
    var path = ""
    let byFolder = parsedByFolder ?? false
    let granularityStrategy: GranularityStrategy = byFolder ? FolderGranularityStrategy() : ModuleGranularityStrategy()
    var xcodeBuildArguments = [String]()
    if let workspace = parsedWorkspace {
        xcodeBuildArguments.append(contentsOf: ["-workspace", workspace])
        let workspacePath = URL(fileURLWithPath: workspace)
        path = workspacePath.deletingLastPathComponent().path
        hasWorkspace = true
    }
    if let scheme = parsedScheme {
        xcodeBuildArguments.append(contentsOf: ["-scheme", scheme])
        hasScheme = true
    }
    if let project = parsedProject {
        xcodeBuildArguments.append(contentsOf: ["-project", project])
        let projectPath = URL(fileURLWithPath: project)
        path = projectPath.deletingLastPathComponent().path
        hasProject = true
    }
    if let target = parsedTarget {
        xcodeBuildArguments.append(contentsOf: ["-target", target])
        hasTarget = true
    }
    let componentNameStrategy: ComponentNameStrategy = byFolder ? FilePathComponentNameStrategy(rootPath: path + "/") : ModuleComponentNameStrategy()

    printStdErr(path)
    printStdErr(xcodeBuildArguments.description)
    printStdErr(moduleNames.description)
    printStdErr(granularityStrategy.description)

    if hasWorkspace && hasProject {
        parser.printUsage(on: stderrStream)
        exit(1)
    }
    if hasWorkspace && !hasScheme {
        parser.printUsage(on: stderrStream)
        exit(1)
    }
    if hasProject && !hasTarget {
        parser.printUsage(on: stderrStream)
        exit(1)
    }

    start(path: path, xcodeBuildArguments: xcodeBuildArguments, moduleNames: moduleNames, granularityStrategy: granularityStrategy, componentNameStrategy: componentNameStrategy)
} else {
    parser.printUsage(on: stderrStream)
}
