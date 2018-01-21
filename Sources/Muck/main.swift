import Foundation
import Basic
import Utility

let arguments = Array(ProcessInfo.processInfo.arguments.dropFirst())
let parser = ArgumentParser(usage: "<options>", overview: "A dependency analyser for Swift projects")
let pathArg: OptionArgument<String> = parser.add(option: "--projectPath", shortName: "-p", kind: String.self, usage: "The root path of the project to analyse (defaults to current directory)")
let modulesArg: OptionArgument<[String]> = parser.add(option: "--modules", shortName: "-m", kind: [String].self, usage: "The Swift modules to analyse (required)")
let byFolderArg: OptionArgument<Bool> = parser.add(option: "--byFolder", shortName: "-f", kind: Bool.self, usage: "Treat folders as components (defaults to modules)")

var parsedPath: String?
var parsedModules: [String]?
var parsedByFolder: Bool?
do {
    let parsedArguments = try parser.parse(arguments)
    parsedPath = parsedArguments.get(pathArg)
    parsedModules = parsedArguments.get(modulesArg)
    parsedByFolder = parsedArguments.get(byFolderArg)
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

    let files = finder.find()
    let components = transformer.transform(files: files)

    let mainSequence = MainSequence(components: components)

    let reporter = CompoundReporter(reporters: [
        AbstractnessReporter(),
        StabilityReporter(),
        CSVReporter(sortBy: .distance),
        StatisticsReporter()
        ])
    print(reporter.makeReport(for: mainSequence))
}

if let modules = parsedModules {
    let path = parsedPath ?? currentWorkingDirectory.asString
    let byFolder = parsedByFolder ?? false
    let granularity: Transformer.ComponentGranularity = byFolder ? .folder : .module
    let xcodeBuildArguments = ["-workspace","Remix.xcworkspace","-scheme","Marketplace"]
    start(path: path, xcodeBuildArguments: xcodeBuildArguments, modules: modules, granularity: granularity)
} else {
    parser.printUsage(on: stdoutStream)
}
