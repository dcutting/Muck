import Foundation

public class FolderGranularityStrategy: GranularityStrategy {

    public init() {}

    public func findComponentID(for declaration: Declaration) -> ComponentID {
        let url = URL(fileURLWithPath: declaration.path)
        return url.deletingLastPathComponent().relativePath
    }

    public var description: String {
        return "treat folders as components"
    }
}
