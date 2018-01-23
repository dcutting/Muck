public typealias ComponentID = String

struct Component {
    let name: String
    var declarations: Declarations
    var references: References
}
