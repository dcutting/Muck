import Foundation

func printStdErr(_ message: String) {
    FileHandle.standardError.write(Data((message + "\n").utf8))
}

extension Double {
    var formatted: String {
        return String(format: "%.4f", self)
    }
}
