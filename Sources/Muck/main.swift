let componentFinder = StubComponentFinder()

let mainSequence = MainSequence(components: componentFinder.find())
print(CSVReporter().makeReport(for: mainSequence, sortBy: .distance))
print()
print(StatisticsReporter().makeReport(for: mainSequence))
print()
