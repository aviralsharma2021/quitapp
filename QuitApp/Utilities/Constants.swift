import SwiftUI

enum AppColors {
    static let primary = Color.orange
    static let secondary = Color.red
    static let accent = Color.yellow

    static let gradient = LinearGradient(
        colors: [Color.orange, Color.red],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let cardBackground = Color(.systemGray6)
    static let cardBackgroundDark = Color(.systemGray5)

    static let success = Color.green
    static let warning = Color.yellow
    static let danger = Color.red

    // Level colors
    static func levelColor(for level: Int) -> Color {
        switch level {
        case 1...10: return .gray
        case 11...25: return .blue
        case 26...50: return .purple
        case 51...75: return .orange
        case 76...100: return .yellow
        default: return .white
        }
    }

    static func levelGradient(for level: Int) -> LinearGradient {
        let color = levelColor(for: level)
        return LinearGradient(
            colors: [color, color.opacity(0.7)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

enum AppConstants {
    // Time intervals in seconds
    static let secondsPerMinute: Double = 60
    static let secondsPerHour: Double = 3600
    static let secondsPerDay: Double = 86400
    static let secondsPerWeek: Double = 604800
    static let secondsPerMonth: Double = 2592000 // 30 days
    static let secondsPerYear: Double = 31536000 // 365 days

    // Health facts
    static let minutesOfLifePerCigarette: Double = 11

    // Default values
    static let defaultCigarettesPerPack = 20
    static let defaultCostPerPack = 15.0
    static let defaultDailyConsumption = 20

    // Animation durations
    static let quickAnimation: Double = 0.2
    static let standardAnimation: Double = 0.3
    static let slowAnimation: Double = 0.5

    // Craving duration estimate (average craving lasts 3-5 minutes)
    static let averageCravingDuration: Double = 240 // 4 minutes in seconds
}

enum AppFonts {
    static let largeTitle = Font.system(size: 34, weight: .bold, design: .rounded)
    static let title = Font.system(size: 28, weight: .bold, design: .rounded)
    static let title2 = Font.system(size: 22, weight: .semibold, design: .rounded)
    static let title3 = Font.system(size: 20, weight: .semibold, design: .rounded)
    static let headline = Font.system(size: 17, weight: .semibold, design: .rounded)
    static let body = Font.system(size: 17, weight: .regular, design: .rounded)
    static let callout = Font.system(size: 16, weight: .regular, design: .rounded)
    static let subheadline = Font.system(size: 15, weight: .regular, design: .rounded)
    static let footnote = Font.system(size: 13, weight: .regular, design: .rounded)
    static let caption = Font.system(size: 12, weight: .regular, design: .rounded)

    // Monospace for numbers/timers
    static let timer = Font.system(size: 48, weight: .bold, design: .monospaced)
    static let timerSmall = Font.system(size: 32, weight: .bold, design: .monospaced)
    static let stat = Font.system(size: 24, weight: .bold, design: .monospaced)
}
