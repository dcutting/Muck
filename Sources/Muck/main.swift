import Foundation
import Basic
import Utility

let arguments = Array(ProcessInfo.processInfo.arguments.dropFirst())
let parser = ArgumentParser(usage: "<options>", overview: "A dependency analyser for Swift projects")
let modulesArg: OptionArgument<[String]> = parser.add(option: "--modules", shortName: "-m", kind: [String].self, usage: "The Swift modules to analyse (required)")
let byFolderArg: OptionArgument<Bool> = parser.add(option: "--byFolder", shortName: "-f", kind: Bool.self, usage: "Treat folders as components (defaults to modules)")

let workspaceArg: OptionArgument<String> = parser.add(option: "--workspace", shortName: "-w", kind: String.self, usage: "The Xcode workspace")
let schemeArg: OptionArgument<String> = parser.add(option: "--scheme", shortName: "-s", kind: String.self, usage: "The Xcode scheme")
let projectArg: OptionArgument<String> = parser.add(option: "--project", shortName: "-p", kind: String.self, usage: "The Xcode project")
let targetArg: OptionArgument<String> = parser.add(option: "--target", shortName: "-t", kind: String.self, usage: "The Xcode target")

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
    print(error.description)
}
catch let error {
    print(error.localizedDescription)
}

func start(path: String, xcodeBuildArguments: [String], modules: [String], granularity: Transformer.ComponentGranularity) {

    let finder = SourceKittenFinder(path: path, xcodeBuildArguments: xcodeBuildArguments, modules: modules)
    let transformer = Transformer(granularity: granularity)

    do {
        let files = try finder.find()
        let components = transformer.transform(files: files)

        let mainSequence = MainSequence(components: components)

        let reporter = CompoundReporter(reporters: [
            AbstractnessReporter(),
            StabilityReporter(),
            CSVReporter(sortBy: .distance),
            StatisticsReporter()
            ])
        print(reporter.makeReport(for: mainSequence))
    } catch FinderError.build(let name) {
        print("Could not build project for workspace/scheme or project/target, or could not find module \(name)")
    } catch {
        print(error)
    }
}

if let modules = parsedModules {
    var path = ""
    let byFolder = parsedByFolder ?? false
    let granularity: Transformer.ComponentGranularity = byFolder ? .folder : .module
    var xcodeBuildArguments = [String]()
    if let workspace = parsedWorkspace {
        xcodeBuildArguments.append(contentsOf: ["-workspace", workspace])
        let workspacePath = URL(fileURLWithPath: workspace)
        path = workspacePath.deletingLastPathComponent().path
    }
    if let scheme = parsedScheme {
        xcodeBuildArguments.append(contentsOf: ["-scheme", scheme])
    }
    if let project = parsedProject {
        xcodeBuildArguments.append(contentsOf: ["-project", project])
        let projectPath = URL(fileURLWithPath: project)
        path = projectPath.deletingLastPathComponent().path
    }
    if let target = parsedTarget {
        xcodeBuildArguments.append(contentsOf: ["-target", target])
    }
    print(path)
    print(xcodeBuildArguments)
    print(modules)
    print(granularity)
    start(path: path, xcodeBuildArguments: xcodeBuildArguments, modules: modules, granularity: granularity)
} else {
    parser.printUsage(on: stdoutStream)
}
