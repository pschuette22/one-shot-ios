import ProjectDescription

let project = Project(
    name: "__APP_NAME__",
    targets: [
        .target(
            name: "__APP_NAME__",
            destinations: [__PLATFORMS__],
            product: .app,
            bundleId: "__BUNDLE_ID__",
            deploymentTargets: .multiplatform(iOS: "18.0", macOS: "15.0", watchOS: "11.0"),
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": ""
                    ]
                ]
            ),
            buildableFolders: [
                "__APP_NAME__/Sources",
                "__APP_NAME__/Resources"
            ],
            entitlements: "__APP_NAME__/Config/__APP_NAME__.entitlements",
            dependencies: [
                .project(target: "ExampleFeature", path: "./Modules/ExampleFeature")
            ]
        ),
        .target(
            name: "__APP_NAME__Tests",
            destinations: [__PLATFORMS__],
            product: .unitTests,
            bundleId: "__BUNDLE_ID__.tests",
            deploymentTargets: .multiplatform(iOS: "18.0", macOS: "15.0", watchOS: "11.0"),
            infoPlist: .default,
            buildableFolders: [
                "__APP_NAME__/Tests"
            ],
            dependencies: [.target(name: "__APP_NAME__")]
        ),
        .target(
            name: "__APP_NAME__SnapshotTests",
            destinations: [__PLATFORMS__],
            product: .unitTests,
            bundleId: "__BUNDLE_ID__.snapshottests",
            deploymentTargets: .multiplatform(iOS: "18.0", macOS: "15.0", watchOS: "11.0"),
            infoPlist: .default,
            buildableFolders: [
                "__APP_NAME__/SnapshotTests"
            ],
            dependencies: [
                .target(name: "__APP_NAME__"),
                .external(name: "SnapshotTesting")
            ]
        )
    ]
)
