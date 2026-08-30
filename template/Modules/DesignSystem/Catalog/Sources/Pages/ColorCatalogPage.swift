import DesignSystem
import SwiftUI

/// Every color token, grouped by namespace.
struct ColorCatalogPage: View {
    static let groups: [(name: String, swatches: [(name: String, color: Color)])] = [
        ("Surface", [
            ("primary", .Surface.primary),
            ("secondary", .Surface.secondary)
        ]),
        ("Text", [
            ("primary", .Text.primary),
            ("secondary", .Text.secondary)
        ]),
        ("Brand", [
            ("primary", .Brand.primary)
        ])
    ]

    var body: some View {
        CatalogPage {
            ForEach(Self.groups, id: \.name) { group in
                CatalogSection(group.name) {
                    ForEach(group.swatches, id: \.name) { swatch in
                        HStack(spacing: DesignSystem.Spacing.md) {
                            RoundedRectangle(cornerRadius: DesignSystem.Radius.sm)
                                .fill(swatch.color)
                                .frame(width: 56, height: 40)
                                .overlay {
                                    RoundedRectangle(cornerRadius: DesignSystem.Radius.sm)
                                        .strokeBorder(Color.Text.secondary.opacity(0.2), lineWidth: 1)
                                }
                            Text("\(group.name).\(swatch.name)").textStyle(.body)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ColorCatalogPage()
}
