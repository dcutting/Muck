struct Stability {

    let fanIn: UInt
    let fanOut: UInt

    var instability: Double {
        let fanTotal = fanIn + fanOut
        precondition(fanTotal > 0, "fanIn + fanOut == 0")
        return Double(fanOut) / Double(fanTotal)
    }
}
