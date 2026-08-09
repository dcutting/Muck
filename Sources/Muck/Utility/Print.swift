import Foundation

public func printStdErr(_ message: String) {
    FileHandle.standardError.write(Data((message + "\n").utf8))
}

public extension Double {
    var formatted: String {
        return String(format: "%.4f", self)
    }
}
