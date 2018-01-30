import Foundation

class FolderGranularityStrategy: GranularityStrategy {

    func findComponentID(for declaration: Declaration) -> ComponentID {
        let url = URL(fileURLWithPath: declaration.path)
        return url.deletingLastPathComponent().relativePath
    }

    var description: String {
        return "treat folders as components"
    }
}
