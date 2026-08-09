import MuckCore

public protocol Finder {
    func find() throws -> [Declaration]
}
