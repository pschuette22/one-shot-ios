import ProjectDescription

let project = Project(
    name: "ExampleFeature",
    targets: [
        .target(
            name: "ExampleFeature",
            destinations: [__PLATFORMS__],
            product: .framework,
            bundleId: "__BUNDLE_ID__.examplefeature",
            deploymentTargets: __DEPLOYMENT_TARGETS__,
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
            deploymentTargets: __DEPLOYMENT_TARGETS__,
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
            deploymentTargets: __DEPLOYMENT_TARGETS__,
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
