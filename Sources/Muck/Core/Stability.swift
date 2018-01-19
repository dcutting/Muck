struct Stability {

    var fanIn: UInt = 0
    var fanOut: UInt = 0

    var instability: Double {
        let fanTotal = fanIn + fanOut
        precondition(fanTotal > 0, "fanIn + fanOut == 0")
        return Double(fanOut) / Double(fanTotal)
    }

    mutating func addFanIn() {
        fanIn += 1
    }

    mutating func addFanOut() {
        fanOut += 1
    }
}
