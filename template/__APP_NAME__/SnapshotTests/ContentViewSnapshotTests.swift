#if canImport(UIKit)
@testable import __APP_NAME__
import SnapshotTesting
import SwiftUI
import Testing
import UIKit

@Suite("ContentView Snapshots", .serialized)
@MainActor
struct ContentViewSnapshotTests {
    @Test("default")
    func defaultState() {
        let view = ContentView()
        let controller = UIHostingController(rootView: view)
        assertSnapshot(of: controller, as: .image(on: .iPhone13))
    }
}
#endif
