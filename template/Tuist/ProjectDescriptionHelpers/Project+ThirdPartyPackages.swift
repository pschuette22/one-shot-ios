import ProjectDescription

// Shared third-party package dependencies.
// Add packages here as `static var` accessors so modules can reference them
// uniformly via `.snapshotTesting` rather than repeating URLs and versions.
public extension Package {
    static var snapshotTesting: Package {
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", .exact("1.18.9"))
    }
}
