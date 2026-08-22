import SwiftUI
import Testing
import UIKit
@testable import DesignSystem

@Suite("Tokens")
struct TokenTests {
    @Test("the spacing scale increases monotonically")
    func spacingIsOrdered() {
        let scale: [CGFloat] = [
            DesignSystem.Spacing.xxs,
            DesignSystem.Spacing.xs,
            DesignSystem.Spacing.sm,
            DesignSystem.Spacing.md,
            DesignSystem.Spacing.lg,
            DesignSystem.Spacing.xl,
            DesignSystem.Spacing.xxl
        ]
        #expect(scale == scale.sorted())
        #expect(Set(scale).count == scale.count)
    }

    @Test("the radius scale increases monotonically")
    func radiusIsOrdered() {
        let scale: [CGFloat] = [DesignSystem.Radius.sm, DesignSystem.Radius.md, DesignSystem.Radius.lg]
        #expect(scale == scale.sorted())
        #expect(Set(scale).count == scale.count)
    }

    /// SwiftUI resolves a missing colorset silently, so a renamed or deleted
    /// entry would only show up as a wrong color at runtime. Every token
    /// declares distinct light and dark values, so a color that resolves
    /// identically in both appearances did not come from the catalog.
    @Test("every color token resolves from the asset catalog")
    func colorsResolve() {
        for token in Self.allTokens {
            let uiColor = UIColor(token.color)
            let light = uiColor.resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
            let dark = uiColor.resolvedColor(with: UITraitCollection(userInterfaceStyle: .dark))
            #expect(light != dark, "\(token.name) did not resolve from the asset catalog")
        }
    }

    static let allTokens: [(name: String, color: Color)] = [
        ("Surface.primary", .Surface.primary),
        ("Surface.secondary", .Surface.secondary),
        ("Text.primary", .Text.primary),
        ("Text.secondary", .Text.secondary),
        ("Brand.primary", .Brand.primary)
    ]
}
