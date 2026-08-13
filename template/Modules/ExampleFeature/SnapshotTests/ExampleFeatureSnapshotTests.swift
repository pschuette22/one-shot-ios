#if canImport(UIKit)
@testable import ExampleFeature
import SnapshotTesting
import SwiftUI
import Testing
import UIKit

@Suite("ExampleFeatureView Snapshots", .serialized)
@MainActor
struct ExampleFeatureSnapshotTests {
    @Test("default")
    func defaultState() {
        let controller = UIHostingController(rootView: ExampleFeatureView())
        assertSnapshot(of: controller, as: .image(on: .iPhone13))
    }
}
#endif
