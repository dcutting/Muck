import Foundation

func printStdErr(_ message: String) {
    if let messageData = (message + "\n").data(using: .utf8) {
        FileHandle.standardError.write(messageData)
    }
}
