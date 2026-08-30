import DesignSystem
import SwiftUI

/// The spacing and corner radius scales, drawn to scale.
struct LayoutCatalogPage: View {
    static let spacings: [(name: String, value: CGFloat)] = [
        ("xxs", DesignSystem.Spacing.xxs),
        ("xs", DesignSystem.Spacing.xs),
        ("sm", DesignSystem.Spacing.sm),
        ("md", DesignSystem.Spacing.md),
        ("lg", DesignSystem.Spacing.lg),
        ("xl", DesignSystem.Spacing.xl),
        ("xxl", DesignSystem.Spacing.xxl)
    ]

    static let radii: [(name: String, value: CGFloat)] = [
        ("sm", DesignSystem.Radius.sm),
        ("md", DesignSystem.Radius.md),
        ("lg", DesignSystem.Radius.lg)
    ]

    var body: some View {
        CatalogPage {
            CatalogSection("Spacing") {
                ForEach(Self.spacings, id: \.name) { entry in
                    HStack(spacing: DesignSystem.Spacing.md) {
                        Text(entry.name)
                            .textStyle(.body)
                            .frame(width: 44, alignment: .leading)
                        Rectangle()
                            .fill(Color.Brand.primary)
                            .frame(width: entry.value, height: 20)
                        Text("\(Int(entry.value)) pt").textStyle(.caption)
                    }
                }
            }

            CatalogSection("Radius") {
                HStack(alignment: .top, spacing: DesignSystem.Spacing.lg) {
                    ForEach(Self.radii, id: \.name) { entry in
                        VStack(spacing: DesignSystem.Spacing.sm) {
                            RoundedRectangle(cornerRadius: entry.value)
                                .fill(Color.Surface.secondary)
                                .frame(width: 88, height: 64)
                                .overlay {
                                    RoundedRectangle(cornerRadius: entry.value)
                                        .strokeBorder(Color.Brand.primary, lineWidth: 1)
                                }
                            Text("\(entry.name) · \(Int(entry.value)) pt").textStyle(.caption)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    LayoutCatalogPage()
}
