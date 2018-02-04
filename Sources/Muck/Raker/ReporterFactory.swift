enum ReportName: String {
    case decl
    case dep
    case dotdep
    case compclean
    case sysclean

    static let all: [ReportName] = [.decl, .dep, .dotdep, .compclean, .sysclean]
}

class ReporterFactory {

    var validReportNames: [String] {
        return ReportName.all.map { $0.rawValue }
    }

    func makeReporter(for names: [String]?) throws -> Reporter {
        let reportNames = names ?? validReportNames
        let reporters = try reportNames.map(makeReporter)
        return CompoundReporter(reporters: reporters)
    }

    private func makeReporter(for name: String) throws -> Reporter {
        guard let reportName = ReportName(rawValue: name) else {
            throw ArgumentsBuilderError.unknownReport(name)
        }
        switch reportName {
        case .decl:
            return DeclarationReporter()
        case .dep:
            return DependencyReporter()
        case .dotdep:
            return DotDependencyReporter()
        case .compclean:
            return ComponentCleanlinessReporter(sortBy: .distance)
        case .sysclean:
            return SystemCleanlinessReporter()
        }
    }
}
