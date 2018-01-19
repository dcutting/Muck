let componentFinder = SourceKittenFinder()
let sourceFiles = componentFinder.find()
let transformer = Transformer()
let mainSequence = MainSequence(components: transformer.transform(sourceFiles: sourceFiles))
let reporter = CompoundReporter(reporters: [
        CSVReporter(sortBy: .distance),
        StatisticsReporter()
    ])
print(reporter.makeReport(for: mainSequence))
