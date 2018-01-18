protocol DoubleConvertible: Numeric {
    func asDouble() -> Double
}

extension Sequence where Element: Numeric {
    var sum: Element {
        return reduce(0, +)
    }
}

extension Collection where Element: FloatingPoint, IndexDistance == Int {
    var mean: Element? {
        guard !isEmpty else { return nil }
        return sum / Element(count)
    }
}

extension Collection where Element: DoubleConvertible, Element: BinaryInteger, IndexDistance == Int {
    var mean: Double? {
        guard !isEmpty else { return nil }
        return sum.asDouble() / count.asDouble()
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

extension Collection where Element: FloatingPoint, IndexDistance == Int {
    var standardDeviation: Element? {
        guard let m = self.mean else { return nil }
        let diffSqs = map { ($0 - m) * ($0 - m) }
        return diffSqs.mean?.squareRoot()
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

func findRating(distance: Double) -> String {
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
