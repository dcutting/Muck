import SourceKittenFramework

class SourceKittenFinder: Finder {
    func find() -> [Component] {
        let skd = File(contents: "import Stuff")
        print(skd.lines)
        return []
    }
}
