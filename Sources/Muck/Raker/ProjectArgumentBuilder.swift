import Foundation
import SPMUtility

class ProjectArgumentBuilder {

    func parse(workspace: String?, project: String?, scheme: String?, target: String?) throws -> (String, [String]) {

        var hasWorkspace = false
        var hasScheme = false
        var hasProject = false
        var hasTarget = false
        var path = ""
        var xcodeBuildArguments = [String]()

        if let workspace = workspace {
            xcodeBuildArguments.append(contentsOf: ["-workspace", workspace])
            path = findPath(forWorkspaceOrProject: workspace)
            hasWorkspace = true
        }
        if let scheme = scheme {
            xcodeBuildArguments.append(contentsOf: ["-scheme", scheme])
            hasScheme = true
        }
        if let project = project {
            xcodeBuildArguments.append(contentsOf: ["-project", project])
            path = findPath(forWorkspaceOrProject: project)
            hasProject = true
        }
        if let target = target {
            xcodeBuildArguments.append(contentsOf: ["-target", target])
            hasTarget = true
        }

        if !(hasWorkspace || hasProject) {
            throw ArgumentsBuilderError.needWorkspaceOrProject
        }
        if hasWorkspace && hasProject {
            throw ArgumentsBuilderError.workspaceAndProjectSpecified
        }
        if hasWorkspace && !hasScheme {
            throw ArgumentsBuilderError.missingScheme
        }
        if hasProject && !(hasTarget || hasScheme) {
            throw ArgumentsBuilderError.missingTargetOrScheme
        }

        return (path, xcodeBuildArguments)
    }

    private func findPath(forWorkspaceOrProject workspaceOrProject: String) -> String {
        let path = URL(fileURLWithPath: workspaceOrProject)
        return path.deletingLastPathComponent().path + "/"
    }
}
