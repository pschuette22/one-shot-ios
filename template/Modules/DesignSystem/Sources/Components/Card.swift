import SwiftUI

/// A rounded container that groups related content on a raised surface.
///
/// The seed component in the design system — a working example of how
/// components consume tokens (spacing, radius, surface color) rather than
/// reaching for literals. Copy its shape when adding new components.
///
/// ```swift
/// Card {
///     Text("Section title").textStyle(.titleSmall)
///     Text("Supporting copy.").textStyle(.caption)
/// }
/// ```
public struct Card<Content: View>: View {
    private let content: Content

    /// Creates a card around the given content.
    ///
    /// - Parameter content: The content, laid out in a leading-aligned `VStack`.
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: DesignSystem.Spacing.sm) {
            content
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(DesignSystem.Spacing.lg)
        .background(Color.Surface.secondary, in: .rect(cornerRadius: DesignSystem.Radius.lg))
    }
}
