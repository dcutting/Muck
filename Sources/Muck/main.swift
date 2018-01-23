import Foundation

func main() {
    let arguments = ArgumentsBuilder().parse(arguments: ProcessInfo.processInfo.arguments)
    Muck().start(arguments: arguments)
}

main()
