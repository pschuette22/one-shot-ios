import Foundation

/// Namespace for the app's shared visual language.
///
/// Layout tokens hang off this enum (``DesignSystem/Spacing``,
/// ``DesignSystem/Radius``); colors and typography extend `Color` and
/// `TextStyle` so they read naturally at the call site.
///
/// ```swift
/// Text("Hello")
///     .textStyle(.titleLarge)
///     .padding(DesignSystem.Spacing.lg)
///     .background(Color.Surface.secondary, in: .rect(cornerRadius: DesignSystem.Radius.md))
/// ```
public enum DesignSystem {}
