import PlaygroundSupport
import SwiftUI
// import DesignSystem   // available once the workspace is generated and the DesignSystem scheme is built

// Iterate on a token or component in isolation. Build the DesignSystem scheme
// first (Product > Build For > Testing) so this playground can import the
// framework. For a full tour of what already exists, run the
// DesignSystemCatalog app instead.
//
// let view = Card {
//     Text("Section title").textStyle(.titleSmall)
// }

let view = VStack(spacing: 12) {
    Text("DesignSystem Playground")
        .font(.title2)
    Text("Edit this file to explore tokens and components.")
        .font(.body)
        .foregroundStyle(.secondary)
}
.padding()
.frame(width: 320, height: 200)

PlaygroundPage.current.setLiveView(view)
