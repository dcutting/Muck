typealias ComponentID = String

struct Component {
    let componentID: ComponentID
    let name: String
    var declarations: Declarations
    var references: References
}
