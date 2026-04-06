import SwiftUI

struct AnimatedCounter: View {
    let value: Double
    let format: String
    var font: Font = AppFonts.stat
    var color: Color = .white

    @State private var displayValue: Double = 0

    var formattedValue: String {
        String(format: format, displayValue)
    }

    var body: some View {
        Text(formattedValue)
            .font(font)
            .foregroundColor(color)
            .monospacedDigit()
            .contentTransition(.numericText(value: displayValue))
            .onAppear {
                withAnimation(.easeOut(duration: 1)) {
                    displayValue = value
                }
            }
            .onChange(of: value) { _, newValue in
                withAnimation(.easeOut(duration: 0.3)) {
                    displayValue = newValue
                }
            }
    }
}

struct AnimatedIntCounter: View {
    let value: Int
    var font: Font = AppFonts.stat
    var color: Color = .white

    @State private var displayValue: Int = 0

    var body: some View {
        Text("\(displayValue)")
            .font(font)
            .foregroundColor(color)
            .monospacedDigit()
            .contentTransition(.numericText(value: Double(displayValue)))
            .onAppear {
                animateValue(to: value)
            }
            .onChange(of: value) { _, newValue in
                animateValue(to: newValue)
            }
    }

    private func animateValue(to target: Int) {
        let steps = 30
        let duration = 0.5
        let stepDuration = duration / Double(steps)

        for step in 0...steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + stepDuration * Double(step)) {
                let progress = Double(step) / Double(steps)
                let eased = 1 - pow(1 - progress, 3) // ease out cubic
                displayValue = Int(Double(displayValue) + (Double(target - displayValue) * eased))
            }
        }
    }
}

struct LiveTimeCounter: View {
    let startDate: Date
    var font: Font = AppFonts.timer
    var showSeconds: Bool = true

    @State private var currentTime = Date()

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var timeInterval: TimeInterval {
        currentTime.timeIntervalSince(startDate)
    }

    var formattedTime: String {
        let interval = max(0, timeInterval)
        let days = Int(interval / 86400)
        let hours = Int((interval.truncatingRemainder(dividingBy: 86400)) / 3600)
        let minutes = Int((interval.truncatingRemainder(dividingBy: 3600)) / 60)
        let seconds = Int(interval.truncatingRemainder(dividingBy: 60))

        if days > 0 {
            if showSeconds {
                return String(format: "%dd %02d:%02d:%02d", days, hours, minutes, seconds)
            } else {
                return String(format: "%dd %02dh %02dm", days, hours, minutes)
            }
        } else {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
    }

    var body: some View {
        Text(formattedTime)
            .font(font)
            .foregroundColor(.white)
            .monospacedDigit()
            .onReceive(timer) { _ in
                currentTime = Date()
            }
    }
}

struct FlipCounter: View {
    let value: Int
    let label: String
    var digitCount: Int = 2

    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 2) {
                ForEach(0..<digitCount, id: \.self) { index in
                    let digit = getDigit(at: index)
                    FlipDigit(digit: digit)
                }
            }

            Text(label)
                .font(AppFonts.caption)
                .foregroundColor(.gray)
        }
    }

    private func getDigit(at index: Int) -> Int {
        let divisor = Int(pow(10.0, Double(digitCount - 1 - index)))
        return (value / divisor) % 10
    }
}

struct FlipDigit: View {
    let digit: Int

    var body: some View {
        Text("\(digit)")
            .font(.system(size: 32, weight: .bold, design: .monospaced))
            .foregroundColor(.white)
            .frame(width: 36, height: 48)
            .background(Color(.systemGray5))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .contentTransition(.numericText(value: Double(digit)))
    }
}

struct TimerDisplay: View {
    let startDate: Date

    @State private var currentTime = Date()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var components: (days: Int, hours: Int, minutes: Int, seconds: Int) {
        let interval = max(0, currentTime.timeIntervalSince(startDate))
        let days = Int(interval / 86400)
        let hours = Int((interval.truncatingRemainder(dividingBy: 86400)) / 3600)
        let minutes = Int((interval.truncatingRemainder(dividingBy: 3600)) / 60)
        let seconds = Int(interval.truncatingRemainder(dividingBy: 60))
        return (days, hours, minutes, seconds)
    }

    var body: some View {
        HStack(spacing: 16) {
            if components.days > 0 {
                FlipCounter(value: components.days, label: "DAYS", digitCount: components.days > 99 ? 3 : 2)
            }
            FlipCounter(value: components.hours, label: "HOURS")
            FlipCounter(value: components.minutes, label: "MINS")
            FlipCounter(value: components.seconds, label: "SECS")
        }
        .onReceive(timer) { _ in
            currentTime = Date()
        }
    }
}

#Preview {
    VStack(spacing: 32) {
        AnimatedCounter(value: 127.50, format: "$%.2f")

        AnimatedIntCounter(value: 847)

        LiveTimeCounter(startDate: Date().addingTimeInterval(-86400 * 3 - 3600 * 5 - 60 * 23))

        TimerDisplay(startDate: Date().addingTimeInterval(-86400 * 7 - 3600 * 12))
    }
    .padding()
    .preferredColorScheme(.dark)
}
