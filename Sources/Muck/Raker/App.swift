public class App {

    public init() {}

    public func start(arguments: [String]) {
        let rakerArguments = ArgumentsBuilder().parse(arguments: arguments)
        Raker().start(arguments: rakerArguments)
    }
}
