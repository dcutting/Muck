import Foundation

func main() {
    let arguments = ArgumentsBuilder().parse(arguments: ProcessInfo.processInfo.arguments)
    MuckApp().start(arguments: arguments)
}

main()
