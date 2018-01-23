public class Raker {

    public struct Arguments {
        let path: String
        let xcodeBuildArguments: [String]
        let moduleNames: [String]
        let isVerbose: Bool
        let granularityStrategy: GranularityStrategy
        let componentNameStrategy: ComponentNameStrategy

        public init(path: String, xcodeBuildArguments: [String], moduleNames: [String], isVerbose: Bool, granularityStrategy: GranularityStrategy, componentNameStrategy: ComponentNameStrategy) {
            self.path = path
            self.xcodeBuildArguments = xcodeBuildArguments
            self.moduleNames = moduleNames
            self.isVerbose = isVerbose
            self.granularityStrategy = granularityStrategy
            self.componentNameStrategy = componentNameStrategy
        }
    }

    public init() {}

    public func start(arguments args: Arguments) {

        do {
            let finder = SourceKittenFinder(path: args.path, xcodeBuildArguments: args.xcodeBuildArguments, moduleNames: args.moduleNames, isVerbose: args.isVerbose)
            let transformer = Transformer(granularityStrategy: args.granularityStrategy, componentNameStrategy: args.componentNameStrategy)

            let files = try finder.find()
            let components = transformer.transform(files: files)
            let mainSequence = MainSequence(components: components)

            let reporter = CompoundReporter(reporters: [
                DeclarationReporter(),
                DependencyReporter(componentNameStrategy: args.componentNameStrategy),
                ComponentCleanlinessReporter(sortBy: .distance),
                OverallCleanlinessReporter()
                ])
            print(reporter.makeReport(for: mainSequence))

        } catch SourceKittenFinderError.build(let name) {
            printStdErr("Error: Could not build specified workspace/scheme or project/target, or could not find module \(name)")
        } catch {
            printStdErr(error.localizedDescription)
        }
    }
}
