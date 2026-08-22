import SwiftUI

public extension Color {
    /// Background colors, ordered from the furthest-back layer forward.
    enum Surface {
        /// The window background.
        public static let primary: Color = DesignSystemAsset.surfacePrimary.swiftUIColor
        /// A recessed background used to group content against ``primary``.
        public static let secondary: Color = DesignSystemAsset.surfaceSecondary.swiftUIColor
    }
}
