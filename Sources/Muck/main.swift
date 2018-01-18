let componentFinder = StubComponentFinder()
let mainSequence = MainSequence(components: componentFinder.find())
let reporter = CompoundReporter(reporters: [
        CSVReporter(sortBy: .distance),
        StatisticsReporter()
    ])
print(reporter.makeReport(for: mainSequence))
