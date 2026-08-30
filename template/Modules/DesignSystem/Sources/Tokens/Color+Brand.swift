import SwiftUI

public extension Color {
    /// The accent palette that carries the app's identity.
    enum Brand {
        /// The primary accent: filled buttons, selection, highlights.
        public static let primary: Color = DesignSystemAsset.brandPrimary.swiftUIColor
    }
}
