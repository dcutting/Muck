protocol DoubleConvertible: Numeric {
    func asDouble() -> Double
}

extension Sequence where Element: Numeric {
    var sum: Element {
        return reduce(0, +)
    }
}

extension Collection where Element: BinaryFloatingPoint {
    var mean: Element? {
        guard !isEmpty else { return nil }
        let n = Element((0 as IndexDistance).distance(to: self.count))
        return sum / n
    }
}

extension Collection where Element: DoubleConvertible, Element: BinaryInteger {
    var mean: Double? {
        guard !isEmpty else { return nil }
        let n = Element((0 as IndexDistance).distance(to: self.count))
        return sum.asDouble() / n.asDouble()
    }
}

extension Collection where Element: DoubleConvertible, Element: Comparable, IndexDistance == Int {
    var median: Double? {
        guard !isEmpty else { return nil }
        let sortedElements = sorted()
        let mid = count / 2
        if count.isEven {
            let midSum = sortedElements[mid-1] + sortedElements[mid]
            return midSum.asDouble() / 2.0
        }
        return sortedElements[mid].asDouble()
    }
}

extension Int {
    var isEven: Bool {
        return self % 2 == 0
    }
}

extension Double: DoubleConvertible {
    func asDouble() -> Double {
        return Double(self)
    }
}

extension Int: DoubleConvertible {
    func asDouble() -> Double {
        return Double(self)
    }
}

extension Float: DoubleConvertible {
    func asDouble() -> Double {
        return Double(self)
    }
}
