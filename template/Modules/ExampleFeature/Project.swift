import ProjectDescription

let project = Project(
    name: "ExampleFeature",
    targets: [
        .target(
            name: "ExampleFeature",
            destinations: [__PLATFORMS__],
            product: .framework,
            bundleId: "__BUNDLE_ID__.examplefeature",
            deploymentTargets: .multiplatform(iOS: "18.0", macOS: "15.0", watchOS: "11.0"),
            infoPlist: .default,
            buildableFolders: [
                "Sources"
            ],
            dependencies: []
        ),
        .target(
            name: "ExampleFeatureTests",
            destinations: [__PLATFORMS__],
            product: .unitTests,
            bundleId: "__BUNDLE_ID__.examplefeature.tests",
            deploymentTargets: .multiplatform(iOS: "18.0", macOS: "15.0", watchOS: "11.0"),
            infoPlist: .default,
            buildableFolders: [
                "Tests"
            ],
            dependencies: [
                .target(name: "ExampleFeature")
            ]
        ),
        .target(
            name: "ExampleFeatureSnapshotTests",
            destinations: [__PLATFORMS__],
            product: .unitTests,
            bundleId: "__BUNDLE_ID__.examplefeature.snapshottests",
            deploymentTargets: .multiplatform(iOS: "18.0", macOS: "15.0", watchOS: "11.0"),
            infoPlist: .default,
            buildableFolders: [
                "SnapshotTests"
            ],
            dependencies: [
                .target(name: "ExampleFeature"),
                .external(name: "SnapshotTesting")
            ]
        )
    ]
)
