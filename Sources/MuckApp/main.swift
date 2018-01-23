import Foundation
import Muck

func main() {
    let arguments = ArgumentsBuilder().parse(arguments: ProcessInfo.processInfo.arguments)
    Raker().start(arguments: arguments)
}

main()
