public protocol DoubleConvertible: Numeric {
    func asDouble() -> Double
}

extension Double: DoubleConvertible {
    public func asDouble() -> Double {
        return Double(self)
    }
}

extension Int: DoubleConvertible {
    public func asDouble() -> Double {
        return Double(self)
    }
}

extension Float: DoubleConvertible {
    public func asDouble() -> Double {
        return Double(self)
    }
}
