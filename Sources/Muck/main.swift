let finder = SourceKittenFinder()
let transformer = Transformer(granularity: .folder)

let files = finder.find()
let components = transformer.transform(files: files)

let mainSequence = MainSequence(components: components)

let reporter = CompoundReporter(reporters: [
    CSVReporter(sortBy: .distance),
    StatisticsReporter()
])
print(reporter.makeReport(for: mainSequence))
