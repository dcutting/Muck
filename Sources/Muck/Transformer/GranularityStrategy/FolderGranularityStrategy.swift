import Foundation

class FolderGranularityStrategy: GranularityStrategy {

    func findComponentID(for file: SourceFile, entity _: Entity) -> ComponentID {
        let url = URL(fileURLWithPath: file.path)
        return url.deletingLastPathComponent().relativePath
    }

    var description: String {
        return "treat folders as components"
    }
}
