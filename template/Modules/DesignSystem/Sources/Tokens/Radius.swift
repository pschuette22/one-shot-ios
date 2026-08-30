import CoreGraphics

public extension DesignSystem {
    /// The corner radius scale for surfaces and controls.
    enum Radius {
        /// 6 points — chips, badges, small tiles.
        public static let sm: CGFloat = 6
        /// 12 points — buttons and inline controls.
        public static let md: CGFloat = 12
        /// 20 points — cards and sheets.
        public static let lg: CGFloat = 20
    }
}
