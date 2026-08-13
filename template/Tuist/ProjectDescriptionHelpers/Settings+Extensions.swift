import ProjectDescription

// Shared build settings applied to every module framework in the workspace.
// Keeping deployment targets, Swift version, and debug-info format in one place
// avoids drift across module Project.swift files.
extension Settings {
    public static var moduleSettings: Settings {
        .settings(
            base: [
                "IPHONEOS_DEPLOYMENT_TARGET": "18.0",
                "MACOSX_DEPLOYMENT_TARGET": "15.0",
                "WATCHOS_DEPLOYMENT_TARGET": "11.0",
                "SWIFT_VERSION": "6.2",
                "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym"
            ],
            configurations: [
                .debug(name: .debug),
                .release(name: .release)
            ]
        )
    }
}
