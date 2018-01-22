protocol DoubleConvertible: Numeric {
    func asDouble() -> Double
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
