import DesignSystem
import SwiftUI

/// Every component, in each state it can render.
struct ComponentsCatalogPage: View {
    var body: some View {
        CatalogPage {
            CatalogSection("Card") {
                Card {
                    Text("Section title").textStyle(.titleSmall)
                    Text("Supporting body copy sits below the title, in the caption color.")
                        .textStyle(.caption)
                }
            }
        }
    }
}

#Preview {
    ComponentsCatalogPage()
}
