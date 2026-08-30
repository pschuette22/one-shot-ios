import ProjectDescription

let snapshotTestables: [TestableTarget] = [
    .testableTarget(target: .project(path: ".", target: "__APP_NAME__SnapshotTests")),
    .testableTarget(target: .project(path: "./Modules/DesignSystem", target: "DesignSystemSnapshotTests"))
]

func snapshotScheme(name: String, recordMode: String) -> Scheme {
    .scheme(
        name: name,
        shared: true,
        buildAction: .buildAction(targets: [
            .project(path: ".", target: "__APP_NAME__SnapshotTests"),
            .project(path: "./Modules/DesignSystem", target: "DesignSystemSnapshotTests")
        ]),
        testAction: .targets(
            snapshotTestables,
            arguments: .arguments(
                environmentVariables: [
                    "SNAPSHOT_TESTING_RECORD": .environmentVariable(
                        value: recordMode,
                        isEnabled: true
                    )
                ]
            )
        )
    )
}

let workspace = Workspace(
    name: "__APP_NAME__",
    projects: ["./", "./Modules/DesignSystem"],
    schemes: [
        snapshotScheme(name: "Snapshots", recordMode: "missing"),
        snapshotScheme(name: "Snapshots-Record", recordMode: "all")
    ]
)
