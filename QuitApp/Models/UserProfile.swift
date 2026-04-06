import Foundation
import SwiftData

enum ProductType: String, Codable, CaseIterable {
    case cigarettes = "Cigarettes"
    case vaping = "Vaping"
    case both = "Both"

    var icon: String {
        switch self {
        case .cigarettes: return "flame"
        case .vaping: return "cloud"
        case .both: return "smoke"
        }
    }
}

@Model
final class UserProfile {
    var id: UUID
    var quitDate: Date
    var productType: String // Store as String for SwiftData compatibility
    var dailyConsumption: Int // cigarettes per day or vape sessions
    var costPerPack: Double // cost per pack or pod
    var packSize: Int // cigarettes per pack (20) or pods per pack
    var currency: String

    // Progress tracking
    var currentXP: Int
    var currentLevel: Int
    var currentStreak: Int
    var longestStreak: Int
    var streakShields: Int
    var totalCravingsResisted: Int
    var lastStreakUpdate: Date

    // Settings
    var notificationsEnabled: Bool
    var dailyReminderTime: Date?

    var productTypeEnum: ProductType {
        get { ProductType(rawValue: productType) ?? .cigarettes }
        set { productType = newValue.rawValue }
    }

    init(
        quitDate: Date = Date(),
        productType: ProductType = .cigarettes,
        dailyConsumption: Int = 20,
        costPerPack: Double = 15.0,
        packSize: Int = 20,
        currency: String = "$"
    ) {
        self.id = UUID()
        self.quitDate = quitDate
        self.productType = productType.rawValue
        self.dailyConsumption = dailyConsumption
        self.costPerPack = costPerPack
        self.packSize = packSize
        self.currency = currency
        self.currentXP = 0
        self.currentLevel = 1
        self.currentStreak = 0
        self.longestStreak = 0
        self.streakShields = 0
        self.totalCravingsResisted = 0
        self.lastStreakUpdate = Date()
        self.notificationsEnabled = true
        self.dailyReminderTime = nil
    }

    // MARK: - Computed Properties

    var timeSinceQuit: TimeInterval {
        Date().timeIntervalSince(quitDate)
    }

    var daysSinceQuit: Int {
        Int(timeSinceQuit / 86400)
    }

    var cigarettesAvoided: Int {
        Int(Double(daysSinceQuit) * Double(dailyConsumption))
    }

    var moneySaved: Double {
        let costPerUnit = costPerPack / Double(packSize)
        return Double(cigarettesAvoided) * costPerUnit
    }

    var lifeRegained: TimeInterval {
        // Each cigarette takes ~11 minutes off life expectancy
        Double(cigarettesAvoided) * 11 * 60
    }

    var lifeRegainedFormatted: String {
        let hours = Int(lifeRegained / 3600)
        let days = hours / 24
        let remainingHours = hours % 24

        if days > 0 {
            return "\(days)d \(remainingHours)h"
        } else {
            return "\(hours)h"
        }
    }

    // MARK: - Level System

    var levelTitle: String {
        switch currentLevel {
        case 1...10: return "Beginner"
        case 11...25: return "Warrior"
        case 26...50: return "Champion"
        case 51...75: return "Legend"
        case 76...100: return "Immortal"
        default: return "Transcendent"
        }
    }

    var xpForNextLevel: Int {
        // Exponential XP curve
        return currentLevel * 100 + (currentLevel * currentLevel * 10)
    }

    var xpProgress: Double {
        let previousLevelXP = (currentLevel - 1) * 100 + ((currentLevel - 1) * (currentLevel - 1) * 10)
        let xpInCurrentLevel = currentXP - previousLevelXP
        let xpNeededForLevel = xpForNextLevel - previousLevelXP
        return Double(xpInCurrentLevel) / Double(xpNeededForLevel)
    }

    func addXP(_ amount: Int) {
        currentXP += amount

        // Check for level up
        while currentXP >= xpForNextLevel && currentLevel < 100 {
            currentLevel += 1
        }
    }
}
