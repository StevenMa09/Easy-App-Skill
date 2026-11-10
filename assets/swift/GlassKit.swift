// GlassKit.swift — system frosted-glass materials
// ADAPT: pass your theme panel color as the wash tint; pass nil for no tint.
//
// ⚠️ Important: `.behindWindow` only works when the window can actually be sampled.
// On an opaque window it degrades to a flat gray slab — the most common cause of "the glass is
// gone". Safer: prefer the native sidebar material (List(.sidebar) with its background intact);
// reserve custom materials for inspectors and overlays.

import SwiftUI
import AppKit

/// System material (SwiftUI wrapper around NSVisualEffectView)
struct VisualEffectView: NSViewRepresentable {
    var material: NSVisualEffectView.Material = .sidebar
    var blending: NSVisualEffectView.BlendingMode = .behindWindow
    var emphasized: Bool = false

    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        apply(view)
        return view
    }

    func updateNSView(_ view: NSVisualEffectView, context: Context) {
        apply(view)
    }

    private func apply(_ view: NSVisualEffectView) {
        view.material = material
        view.blendingMode = blending
        view.state = .followsWindowActiveState
        view.isEmphasized = emphasized
    }
}

extension View {
    /// Frosted background + optional tint (the tint sits under content, so text stays clean)
    /// - Parameters:
    ///   - wash: theme tint; `nil` means pure system material
    ///   - panel: solid color to darken/lighten; lower opacity = more translucent
    func frostedBackground(material: NSVisualEffectView.Material = .sidebar,
                           wash: Color? = nil,
                           panel: Color = .clear,
                           panelOpacity: Double = 0) -> some View {
        background {
            ZStack {
                VisualEffectView(material: material, blending: .behindWindow)
                if panelOpacity > 0 { panel.opacity(panelOpacity) }
                if let wash { wash }
            }
            .ignoresSafeArea()
        }
    }
}
