// TimeInput.swift — time input (12/24h + AM/PM) and a date popover
// Extracted from a real project. Hit twice: the 12-hour setting was flipped but the field stayed
// 24-hour. Fix: display and input must read the same settings source, and conversion must be a
//
// pure, testable function.  ADAPT: point `showsPeriod` at your settings; replace `dayLabel`.

import SwiftUI
import AppKit

/// "Hour : minute" input. 24-hour mode shows 0–23; 12-hour mode shows 1–12 plus AM/PM.
///
/// Usage:
/// ```swift
/// HourMinuteField(minutes: task.minutesOfDay,
///                 showsPeriod: !settings.uses24Hour) { newMinutes in
///     task.minutesOfDay = newMinutes
/// }
/// ```
struct HourMinuteField: View {
    let minutes: Int
    var maxMinutes: Int = 23 * 60 + 59
    /// true = 12-hour clock (with an AM/PM toggle)
    var showsPeriod: Bool = false
    var tint: Color = .accentColor
    let onChange: (Int) -> Void

    @State private var hourText: String = ""
    @State private var minuteText: String = ""
    @State private var isPM: Bool = false
    @FocusState private var focus: Field?

    private enum Field { case hour, minute }

    private var maxHour: Int { showsPeriod ? 12 : max(0, maxMinutes / 60) }

    var body: some View {
        HStack(spacing: 3) {
            box(text: $hourText, field: .hour, width: 32)
                .onSubmit { commit() }
            Text(":").font(.system(size: 12, weight: .medium)).foregroundStyle(.secondary)
            box(text: $minuteText, field: .minute, width: 32)
                .onSubmit { commit() }

            if showsPeriod {
                HStack(spacing: 2) {
                    periodButton("AM", value: false)
                    periodButton("PM", value: true)
                }
                .fixedSize()
                .padding(.leading, 3)
            }
        }
        .onAppear(perform: sync)
        .onChange(of: minutes) { _, _ in sync() }
        .onChange(of: focus) { _, newValue in
            if newValue == nil { commit() }
        }
    }

    private func periodButton(_ title: String, value: Bool) -> some View {
        Button {
            isPM = value
            commit()
        } label: {
            Text(title)
                .font(.system(size: 10, weight: .semibold))
                .fixedSize()
                .foregroundStyle(isPM == value ? tint : Color.secondary)
                .padding(.horizontal, 5)
                .padding(.vertical, 3)
                .background(RoundedRectangle(cornerRadius: 5)
                    .fill(isPM == value ? tint.opacity(0.14) : Color.primary.opacity(0.05)))
        }
        .buttonStyle(.plain)
    }

    private func box(text: Binding<String>, field: Field, width: CGFloat) -> some View {
        TextField("", text: text)
            .textFieldStyle(.plain)
            .multilineTextAlignment(.center)
            .font(.system(size: 12).monospacedDigit())
            .frame(width: width)
            .padding(.vertical, 4)
            .background(RoundedRectangle(cornerRadius: 6)
                .fill(Color.primary.opacity(focus == field ? 0.09 : 0.055)))
            .focused($focus, equals: field)
    }

    private func sync() {
        let hour24 = minutes / 60
        if showsPeriod {
            let h12 = hour24 % 12
            hourText = String(h12 == 0 ? 12 : h12)
            isPM = hour24 >= 12
        } else {
            hourText = String(hour24)
        }
        minuteText = String(format: "%02d", minutes % 60)
    }

    private func commit() {
        let total = Self.resolveMinutes(hour: Int(hourText) ?? (minutes / 60),
                                        minute: Int(minuteText) ?? (minutes % 60),
                                        isPM: isPM,
                                        showsPeriod: showsPeriod,
                                        maxMinutes: maxMinutes)
        if total != minutes { onChange(total) }
        minutesSync(total)
    }

    private func minutesSync(_ total: Int) {
        if showsPeriod {
            let h12 = (total / 60) % 12
            hourText = String(h12 == 0 ? 12 : h12)
            isPM = total / 60 >= 12
        } else {
            hourText = String(total / 60)
        }
        minuteText = String(format: "%02d", total % 60)
    }

    /// Pure function: hour + minute + AM/PM -> minutes since midnight. Unit-testable.
    static func resolveMinutes(hour rawHour: Int, minute rawMinute: Int,
                               isPM: Bool, showsPeriod: Bool, maxMinutes: Int) -> Int {
        var minute = min(59, max(0, rawMinute))
        if showsPeriod {
            var hour = min(12, max(1, rawHour))
            if hour == 12 { hour = 0 }
            return min(maxMinutes, max(0, (hour + (isPM ? 12 : 0)) * 60 + minute))
        }
        let maxHour = max(0, maxMinutes / 60)
        let hour = min(maxHour, max(0, rawHour))
        if hour == maxHour && minute > maxMinutes % 60 { minute = maxMinutes % 60 }
        return hour * 60 + minute
    }
}

/// Date field: click to open a calendar. Fits custom UI better than a system compact picker.
struct DayField: View {
    let date: Date?
    let onChange: (Date) -> Void
    var tint: Color = .accentColor
    /// ADAPT: use your own date format (e.g. "MMM d")
    var dayLabel: (Date) -> String = { d in
        let f = DateFormatter()
        f.dateFormat = "MMM d"
        return f.string(from: d)
    }

    @State private var showPicker = false

    var body: some View {
        Button {
            showPicker = true
        } label: {
            HStack(spacing: 4) {
                Image(systemName: "calendar").font(.system(size: 10, weight: .medium))
                Text(date.map(dayLabel) ?? "Add date").font(.system(size: 12))
                Image(systemName: "chevron.down")
                    .font(.system(size: 8, weight: .bold)).foregroundStyle(.tertiary)
            }
            .foregroundStyle(date == nil ? Color.secondary : Color.primary)
            .padding(.horizontal, 9)
            .padding(.vertical, 4)
            .background(RoundedRectangle(cornerRadius: 6).fill(Color.primary.opacity(0.055)))
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .popover(isPresented: $showPicker, arrowEdge: .bottom) {
            DayPickerPopover(date: date, tint: tint,
                             onChange: onChange,
                             isPresented: $showPicker)
        }
    }
}

/// Calendar popover. Easy to add shortcuts like Today / Tomorrow / Next Monday.
struct DayPickerPopover: View {
    let date: Date?
    var tint: Color = .accentColor
    let onChange: (Date) -> Void
    @Binding var isPresented: Bool

    @State private var draft: Date
    private let cal = Calendar.current

    init(date: Date?, tint: Color = .accentColor,
         onChange: @escaping (Date) -> Void, isPresented: Binding<Bool>) {
        self.date = date
        self.tint = tint
        self.onChange = onChange
        self._isPresented = isPresented
        self._draft = State(initialValue: date ?? Date())
    }

    var body: some View {
        VStack(spacing: 10) {
            DatePicker("", selection: $draft, displayedComponents: .date)
                .datePickerStyle(.graphical)
                .labelsHidden()
            HStack(spacing: 8) {
                Button("Cancel") { isPresented = false }
                    .buttonStyle(.plain).foregroundStyle(.secondary)
                Spacer()
                Button("Done") {
                    onChange(draft)
                    isPresented = false
                }
                .buttonStyle(.plain).foregroundStyle(tint)
            }
            .font(.system(size: 12))
            .padding(.horizontal, 6)
        }
        .padding(12)
        .frame(width: 260)
    }
}
