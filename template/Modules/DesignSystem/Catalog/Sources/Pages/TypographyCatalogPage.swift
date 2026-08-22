import DesignSystem
import SwiftUI

/// The `TextStyle` scale, each entry rendered in its own style.
struct TypographyCatalogPage: View {
    static let styles: [(name: String, style: TextStyle)] = [
        ("titleLarge", .titleLarge),
        ("titleSmall", .titleSmall),
        ("body", .body),
        ("caption", .caption)
    ]

    var body: some View {
        CatalogPage {
            CatalogSection("Scale") {
                ForEach(Self.styles, id: \.name) { entry in
                    VStack(alignment: .leading, spacing: DesignSystem.Spacing.xxs) {
                        Text(entry.name).textStyle(entry.style)
                        Text("\(Int(entry.style.size)) pt").textStyle(.caption)
                    }
                }
            }

            CatalogSection("Disabled") {
                VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
                    ForEach(Self.styles, id: \.name) { entry in
                        Text(entry.name).textStyle(entry.style)
                    }
                }
                .disabled(true)
            }
        }
    }
}

#Preview {
    TypographyCatalogPage()
}
