// ToastBanner.swift — bottom toast (optionally with an Undo button)
// ADAPT: run copy through your localization function.
//
// Usage:
// ```swift
// .overlay(alignment: .bottom) {
//     if let msg = model.toastMessage {
//         ToastBanner(message: msg, actionTitle: "Undo") { model.undo() }
//     }
// }
// .animation(Motion.of(Motion.row), value: model.toastMessage)
// ```

import SwiftUI

struct ToastBanner: View {
    let message: String
    var actionTitle: String? = nil
    var onAction: (() -> Void)? = nil
    var onDismiss: (() -> Void)? = nil
    var tint: Color = .accentColor

    var body: some View {
        HStack(spacing: 12) {
            Text(message)
                .font(.system(size: 11.5))
                .lineLimit(1)
            Spacer(minLength: 8)
            if let actionTitle, let onAction {
                Button(actionTitle, action: onAction)
                    .buttonStyle(.plain)
                    .font(.system(size: 11.5, weight: .semibold))
                    .foregroundStyle(tint)
            }
            if let onDismiss {
                Button(action: onDismiss) {
                    Image(systemName: "xmark")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundStyle(.tertiary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 9)
        .frame(maxWidth: 420)
        .background(.regularMaterial, in: Capsule())
        .overlay(Capsule().strokeBorder(Color.primary.opacity(0.10), lineWidth: 0.8))
        .shadow(color: .black.opacity(0.16), radius: 10, y: 4)
        .padding(.bottom, 18)
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}
