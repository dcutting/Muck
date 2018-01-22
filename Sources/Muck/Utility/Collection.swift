extension Collection where Element: Collection {
    func flattened() -> Array<Element.Element> {
        return Array(self.joined())
    }
}
