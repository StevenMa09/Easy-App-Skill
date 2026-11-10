// FormControls.swift — custom form controls (segmented / dropdown / switch)
// ADAPT: set `tint`'s default to your accent color; wrap copy in your localization function.

import SwiftUI

/// Segmented control: custom capsule with the selected segment filled at low tint opacity.
/// Quieter than the system Picker(.segmented), and fully color-controllable.
struct SegmentedField<Item: Hashable>: View {
    let items: [Item]
    let label: (Item) -> String
    @Binding var selection: Item
    var tint: Color = .accentColor

    @Namespace private var pill

    var body: some View {
        HStack(spacing: 2) {
            ForEach(Array(items.enumerated()), id: \.offset) { _, item in
                let isOn = item == selection
                Button {
                    selection = item
                } label: {
                    Text(label(item))
                        .font(.system(size: 10.5, weight: isOn ? .semibold : .regular))
                        .lineLimit(1)
                        .fixedSize(horizontal: true, vertical: false)
                        .foregroundStyle(isOn ? Color.primary : Color.secondary)
                        .padding(.horizontal, 7)
                        .padding(.vertical, 4)
                        .background {
                            if isOn {
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(tint.opacity(0.16))
                                    .matchedGeometryEffect(id: "seg", in: pill)
                            }
                        }
                        .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            }
        }
        .padding(2)
        .background(RoundedRectangle(cornerRadius: 7).fill(Color.primary.opacity(0.05)))
        .animation(Motion.of(Motion.hover), value: selection)
    }
}

/// Dropdown: quiet capsule plus a popover with checkmarks.
struct MenuField<Item: Hashable>: View {
    let items: [Item]
    let label: (Item) -> String
    @Binding var selection: Item
    var tint: Color = .accentColor

    @State private var showPopover = false
    @State private var hovering = false

    var body: some View {
        Button {
            showPopover = true
        } label: {
            HStack(spacing: 4) {
                Text(label(selection)).font(.system(size: 11.5))
                Image(systemName: "chevron.down")
                    .font(.system(size: 6.5, weight: .bold))
                    .foregroundStyle(.tertiary)
            }
            .foregroundStyle(.primary)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(RoundedRectangle(cornerRadius: 6)
                .fill(Color.primary.opacity(hovering ? 0.10 : 0.06)))
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .onHover { hovering = $0 }
        .popover(isPresented: $showPopover, arrowEdge: .bottom) {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(Array(items.enumerated()), id: \.offset) { _, item in
                    Button {
                        selection = item
                        showPopover = false
                    } label: {
                        HStack(spacing: 6) {
                            Text(label(item)).font(.system(size: 12))
                            Spacer(minLength: 12)
                            if item == selection {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 9, weight: .bold))
                                    .foregroundStyle(tint)
                            }
                        }
                        .foregroundStyle(item == selection ? tint : Color.primary)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.vertical, 4)
            .frame(width: 160)
        }
    }
}

/// Custom switch: capsule track, tint when on.
struct ToggleSwitch: View {
    @Binding var isOn: Bool
    var tint: Color = .accentColor

    var body: some View {
        Button {
            withAnimation(.easeOut(duration: 0.16)) { isOn.toggle() }
        } label: {
            Capsule()
                .fill(isOn ? tint : Color.primary.opacity(0.14))
                .frame(width: 36, height: 22)
                .overlay(alignment: isOn ? .trailing : .leading) {
                    Circle().fill(Color.white)
                        .frame(width: 18, height: 18)
                        .padding(2)
                        .shadow(color: .black.opacity(0.18), radius: 1, y: 0.5)
                }
                .contentShape(Capsule())
        }
        .pressable(0.94)
    }
}
