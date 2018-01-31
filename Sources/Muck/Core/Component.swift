typealias ComponentID = String

struct Component {
    let componentID: ComponentID
    let name: String
    var types: Types
    var references: References
}
