import Basic

func printStdErr(_ message: String) {
    stderrStream <<< message <<< "\n"
    stderrStream.flush()
}
