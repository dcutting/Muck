import Basic

func printStdErr(_ message: String) {
    stderrStream <<< message <<< "\n"
    stderrStream.flush()
}

extension Double {
    var formatted: String {
        return String(format: "%.4f", self)
    }
}
