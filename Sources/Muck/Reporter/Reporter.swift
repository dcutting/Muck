protocol Reporter {
    var name: String { get }
    func makeReport(for: MainSequence) -> String
}

extension Reporter {
    
    func calculateRating(distance: Double) -> String {
        if distance < 0.1 {
            return "A"
        } else if distance < 0.3 {
            return "B"
        } else if distance < 0.5 {
            return "C"
        } else {
            return "D"
        }
    }
}
