import SwiftUI

// MARK: - Style

/// A named typographic treatment: size, weight, typeface design, and color.
///
/// Apply one with ``SwiftUI/View/textStyle(_:color:)`` rather than setting
/// `.font` and `.foregroundStyle` separately, so that Dynamic Type scaling and
/// the disabled-state color come along with it.
public struct TextStyle: Sendable {
    /// The point size at the default Dynamic Type setting.
    public let size: CGFloat
    /// The system text style this size scales against.
    public let relativeTo: Font.TextStyle
    /// The stroke weight.
    public let weight: Font.Weight
    /// The typeface design.
    public let design: Font.Design
    /// The foreground color while the view is enabled.
    public let enabledColor: Color
    /// The foreground color while the view is disabled.
    public let disabledColor: Color

    /// Creates a text style.
    ///
    /// - Parameters:
    ///   - size: The point size at the default Dynamic Type setting.
    ///   - relativeTo: The system text style to scale against.
    ///   - weight: The stroke weight.
    ///   - design: The typeface design.
    ///   - enabledColor: The foreground color while enabled.
    ///   - disabledColor: The foreground color while disabled.
    public init(
        size: CGFloat,
        relativeTo: Font.TextStyle = .body,
        weight: Font.Weight = .regular,
        design: Font.Design = .default,
        enabledColor: Color = .Text.primary,
        disabledColor: Color = .Text.secondary
    ) {
        self.size = size
        self.relativeTo = relativeTo
        self.weight = weight
        self.design = design
        self.enabledColor = enabledColor
        self.disabledColor = disabledColor
    }

    /// Returns the style's font at an explicit point size.
    ///
    /// - Parameter size: The point size, already scaled for Dynamic Type.
    /// - Returns: A font carrying the style's weight and design.
    public func font(at size: CGFloat) -> Font {
        .system(size: size, weight: weight, design: design)
    }
}

// MARK: - Scale

public extension TextStyle {
    /// 28 pt semibold rounded — a screen title.
    static let titleLarge = TextStyle(
        size: 28,
        relativeTo: .title,
        weight: .semibold,
        design: .rounded
    )

    /// 20 pt semibold — a section heading.
    static let titleSmall = TextStyle(
        size: 20,
        relativeTo: .title3,
        weight: .semibold
    )

    /// 17 pt regular — body copy.
    static let body = TextStyle(
        size: 17,
        relativeTo: .body
    )

    /// 13 pt regular in ``Color/Text/secondary`` — captions and footnotes.
    static let caption = TextStyle(
        size: 13,
        relativeTo: .caption,
        enabledColor: .Text.secondary
    )
}

// MARK: - Modifier

/// Applies a ``TextStyle``, scaling its size for Dynamic Type and resolving its
/// color against the environment's enabled state.
public struct TextStyleModifier: ViewModifier {
    @Environment(\.isEnabled) private var isEnabled: Bool
    @ScaledMetric private var scaledSize: CGFloat

    private let style: TextStyle
    private let colorOverride: Color?

    /// Creates the modifier.
    ///
    /// - Parameters:
    ///   - style: The style to apply.
    ///   - color: A color that replaces the style's own, ignoring enabled state.
    public init(style: TextStyle, color: Color? = nil) {
        self.style = style
        colorOverride = color
        _scaledSize = ScaledMetric(wrappedValue: style.size, relativeTo: style.relativeTo)
    }

    private var resolvedColor: Color {
        colorOverride ?? (isEnabled ? style.enabledColor : style.disabledColor)
    }

    public func body(content: Content) -> some View {
        content
            .font(style.font(at: scaledSize))
            .foregroundStyle(resolvedColor)
    }
}

// MARK: - Convenience

public extension View {
    /// Applies a ``TextStyle`` to the view's text.
    ///
    /// - Parameters:
    ///   - style: The style to apply.
    ///   - color: A color that replaces the style's own. Pass `nil` to keep the
    ///     style's enabled and disabled colors.
    /// - Returns: The view, styled.
    func textStyle(_ style: TextStyle, color: Color? = nil) -> some View {
        modifier(TextStyleModifier(style: style, color: color))
    }
}
