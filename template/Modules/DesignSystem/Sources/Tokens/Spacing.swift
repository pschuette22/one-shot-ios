import CoreGraphics

public extension DesignSystem {
    /// The 4-point spacing scale used for padding, insets, and stack spacing.
    ///
    /// Layout gaps should come from this scale rather than literals so that
    /// rhythm stays consistent across screens.
    enum Spacing {
        /// 2 points — hairline separation between tightly coupled elements.
        public static let xxs: CGFloat = 2
        /// 4 points — icon-to-label gaps.
        public static let xs: CGFloat = 4
        /// 8 points — spacing within a component.
        public static let sm: CGFloat = 8
        /// 12 points — spacing between related components.
        public static let md: CGFloat = 12
        /// 16 points — the default screen margin.
        public static let lg: CGFloat = 16
        /// 24 points — spacing between sections.
        public static let xl: CGFloat = 24
        /// 32 points — spacing between major regions.
        public static let xxl: CGFloat = 32
    }
}
