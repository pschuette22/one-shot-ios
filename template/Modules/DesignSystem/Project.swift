import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "DesignSystem",
    settings: .moduleSettings,
    targets: [
        .target(
            name: "DesignSystem",
            destinations: [__PLATFORMS__],
            product: .framework,
            bundleId: "__BUNDLE_ID__.designsystem",
            deploymentTargets: __DEPLOYMENT_TARGETS__,
            infoPlist: .default,
            buildableFolders: [
                "Sources",
                "Resources"
            ],
            dependencies: []
        ),
        // The catalog renders every token and component in isolation; it ships
        // with the module rather than the app so the module stays runnable on
        // its own.
        .target(
            name: "DesignSystemCatalog",
            destinations: [__PLATFORMS__],
            product: .app,
            bundleId: "__BUNDLE_ID__.designsystemcatalog",
            deploymentTargets: __DEPLOYMENT_TARGETS__,
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": ""
                    ]
                ]
            ),
            buildableFolders: [
                "Catalog/Sources"
            ],
            dependencies: [
                .target(name: "DesignSystem")
            ]
        ),
        .target(
            name: "DesignSystemTests",
            destinations: [__PLATFORMS__],
            product: .unitTests,
            bundleId: "__BUNDLE_ID__.designsystem.tests",
            deploymentTargets: __DEPLOYMENT_TARGETS__,
            infoPlist: .default,
            buildableFolders: [
                "Tests"
            ],
            dependencies: [
                .target(name: "DesignSystem")
            ]
        ),
        .target(
            name: "DesignSystemSnapshotTests",
            destinations: [__PLATFORMS__],
            product: .unitTests,
            bundleId: "__BUNDLE_ID__.designsystem.snapshottests",
            deploymentTargets: __DEPLOYMENT_TARGETS__,
            infoPlist: .default,
            buildableFolders: [
                "SnapshotTests"
            ],
            dependencies: [
                .target(name: "DesignSystem"),
                .external(name: "SnapshotTesting")
            ]
        )
    ]
)
