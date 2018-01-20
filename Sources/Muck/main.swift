let finder = SourceKittenFinder()
let transformer = Transformer(granularity: .module)

let files = finder.find()
let components = transformer.transform(files: files)

let mainSequence = MainSequence(components: components)

let reporter = CompoundReporter(reporters: [
    DependencyReporter(),
    CSVReporter(sortBy: .distance),
    StatisticsReporter()
])
print(reporter.makeReport(for: mainSequence))
