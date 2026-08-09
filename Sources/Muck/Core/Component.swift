public typealias ComponentID = String

public struct Component {
    public let componentID: ComponentID
    public let name: String
    public var types: Types
    public var references: References
}
