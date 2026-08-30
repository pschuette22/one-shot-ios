import SwiftUI

public extension Color {
    /// Foreground colors for text and glyphs, ordered by descending emphasis.
    enum Text {
        /// Headlines and body copy.
        public static let primary: Color = DesignSystemAsset.textPrimary.swiftUIColor
        /// Supporting copy, captions, and disabled controls.
        public static let secondary: Color = DesignSystemAsset.textSecondary.swiftUIColor
    }
}
