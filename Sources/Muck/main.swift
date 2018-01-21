let finder = SourceKittenFinder(path: "/Users/dcutting/Dropbox/Dan/Code/Gloop", modules: ["Gloop", "Barbaloot"])
let transformer = Transformer(granularity: .module)

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
