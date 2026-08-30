import DesignSystem
import SnapshotTesting
import SwiftUI
import Testing
import UIKit

@Suite("Component Snapshots", .serialized)
@MainActor
struct ComponentSnapshotTests {
    @Test("card")
    func card() {
        let view = stack {
            Card {
                Text("Section title").textStyle(.titleSmall)
                Text("Supporting body copy sits below the title, in the caption color.")
                    .textStyle(.caption)
            }
        }
        assertSnapshot(of: UIHostingController(rootView: view), as: .image(on: .iPhone13))
    }

    @Test("card - dark mode")
    func cardDarkMode() {
        let view = stack {
            Card {
                Text("Section title").textStyle(.titleSmall)
                Text("Supporting body copy sits below the title, in the caption color.")
                    .textStyle(.caption)
            }
        }
        assertSnapshot(
            of: UIHostingController(rootView: view),
            as: .image(on: .iPhone13, traits: .init(userInterfaceStyle: .dark))
        )
    }

    private func stack(@ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.lg) {
            content()
        }
        .padding(DesignSystem.Spacing.lg)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.Surface.primary)
    }
}
