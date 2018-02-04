private enum GranularityName: String {
    case type
    case file
    case folder
    case module

    static let all: [GranularityName] = [.type, .file, .folder, .module]
}

class GranularityArgumentBuilder {

    var validGranularityNames: [String] {
        return GranularityName.all.map { $0.rawValue }
    }

    func makeStrategies(granularity: String?, path: String) throws -> (GranularityStrategy, ComponentNameStrategy) {

        let granularity = granularity ?? GranularityName.module.rawValue

        guard let granularityName = GranularityName(rawValue: granularity) else {
            throw ArgumentsBuilderError.invalidGranularity(granularity)
        }

        let granularityStrategy: GranularityStrategy
        let componentNameStrategy: ComponentNameStrategy
        switch granularityName {
        case .type:
            granularityStrategy = TypeGranularityStrategy()
            componentNameStrategy = IdentityComponentNameStrategy()
        case .file:
            granularityStrategy = FileGranularityStrategy()
            componentNameStrategy = makeStrippedComponentNameStrategy(path: path)
        case .folder:
            granularityStrategy = FolderGranularityStrategy()
            componentNameStrategy = makeStrippedComponentNameStrategy(path: path)
        case .module:
            granularityStrategy = ModuleGranularityStrategy()
            componentNameStrategy = IdentityComponentNameStrategy()
        }
        return (granularityStrategy, componentNameStrategy)
    }

    private func makeStrippedComponentNameStrategy(path: String) -> ComponentNameStrategy {
        return StrippedComponentNameStrategy(prefix: path + "/", suffix: ".swift")
    }
}
