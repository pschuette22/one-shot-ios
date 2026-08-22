import DesignSystem
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: DesignSystem.Spacing.lg) {
            Text("__APP_NAME__")
                .textStyle(.titleLarge)
            Card {
                Text("Design system installed")
                    .textStyle(.titleSmall)
                Text("Browse tokens and components in the DesignSystemCatalog scheme.")
                    .textStyle(.caption)
            }
        }
        .padding(DesignSystem.Spacing.lg)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color.Surface.primary)
    }
}

#Preview {
    ContentView()
}
