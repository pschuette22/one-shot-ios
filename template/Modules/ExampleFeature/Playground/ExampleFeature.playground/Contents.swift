import PlaygroundSupport
import SwiftUI
// import ExampleFeature   // available once the workspace is generated and the ExampleFeature scheme is built

// Iterate on ExampleFeature APIs in isolation.
// Build the ExampleFeature scheme first (Product > Build For > Testing) so this
// playground can import the framework.

let view = VStack(spacing: 12) {
    Text("ExampleFeature Playground")
        .font(.title2)
    Text("Edit this file to explore module APIs.")
        .font(.body)
        .foregroundStyle(.secondary)
}
.padding()
.frame(width: 320, height: 200)

PlaygroundPage.current.setLiveView(view)
