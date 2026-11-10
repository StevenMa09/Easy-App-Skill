// MotionKit.swift — motion tokens + press feedback + Reduce Motion
// Extracted from a real macOS project, with project dependencies removed.
// ADAPT: nothing to change; use as-is.

import SwiftUI
import AppKit

/// Central motion parameters. Every animation comes from here so timing can be tuned globally.
enum Motion {
    static let check = Animation.snappy(duration: 0.28, extraBounce: 0.12)
    static let row = Animation.snappy(duration: 0.3, extraBounce: 0.05)
    static let reorder = Animation.smooth(duration: 0.36)
    static let hover = Animation.easeOut(duration: 0.13)
    static let panel = Animation.smooth(duration: 0.3)
    static let theme = Animation.easeInOut(duration: 0.28)

    /// Caches the Reduce Motion setting.
    /// ⚠️ Never call NSWorkspace.shared.accessibilityDisplayShouldReduceMotion directly:
    /// body evaluations would run a cross-process query and turn scrolling into a slideshow.
    nonisolated(unsafe) private static var cachedReduce: Bool =
        NSWorkspace.shared.accessibilityDisplayShouldReduceMotion

    static var reduceMotion: Bool { cachedReduce }

    static func refreshReduceMotion() {
        cachedReduce = NSWorkspace.shared.accessibilityDisplayShouldReduceMotion
    }

    /// With Reduce Motion on, degrade everything to a short cross-fade.
    static func of(_ animation: Animation) -> Animation {
        cachedReduce ? .easeInOut(duration: 0.18) : animation
    }
}

/// Button style that shrinks slightly while pressed (the system default gives no feedback).
struct PressableStyle: ButtonStyle {
    var scale: CGFloat = 0.97

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scale : 1)
            .opacity(configuration.isPressed ? 0.86 : 1)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}

extension View {
    /// Shorthand for press feedback: `Button { ... }.pressable()`
    func pressable(_ scale: CGFloat = 0.97) -> some View {
        buttonStyle(PressableStyle(scale: scale))
    }
}
