import ProjectDescription

// Shared build settings applied across the workspace. Keeping deployment
// targets, Swift version, and debug-info format in one place avoids drift
// across per-project `Project.swift` files.
extension Settings {
    private static var baseSettings: SettingsDictionary {
        [
            "IPHONEOS_DEPLOYMENT_TARGET": "18.0",
            "MACOSX_DEPLOYMENT_TARGET": "15.0",
            "WATCHOS_DEPLOYMENT_TARGET": "11.0",
            "SWIFT_VERSION": "6",
            "DEBUG_INFORMATION_FORMAT": "dwarf-with-dsym"
        ]
    }

    /// Base settings for framework modules. No code signing — frameworks
    /// consume the app's signing when linked.
    public static var moduleSettings: Settings {
        .settings(
            base: baseSettings,
            configurations: [
                .debug(name: .debug),
                .release(name: .release)
            ]
        )
    }

    /// Base settings for the root app project. Adds automatic code signing
    /// keyed off `TUIST_DEV_TEAM_ID` in `.env.local` — an empty team ID lets
    /// simulator builds proceed without prompting, while device builds pick
    /// up the developer's team when set.
    public static var appSettings: Settings {
        .settings(
            base: baseSettings.automaticCodeSigning(
                devTeam: Environment.devTeamId.getString(default: "")
            ),
            configurations: [
                .debug(name: .debug),
                .release(name: .release)
            ]
        )
    }
}
