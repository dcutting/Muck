extension String {
    func strip(prefix: String, suffix: String) -> String {
        var result = self
        if result.hasPrefix(prefix) {
            result = String(result.dropFirst(prefix.count))
        }
        if result.hasSuffix(suffix) {
            result = String(result.dropLast(suffix.count))
        }
        return result
    }
}
