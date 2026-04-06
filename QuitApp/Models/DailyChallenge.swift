import Foundation
import SwiftData

enum ChallengeType: String, Codable, CaseIterable {
    case breathing = "Mindful Moment"
    case logging = "Craving Logger"
    case savings = "Money Counter"
    case health = "Health Check"
    case letter = "Letter Writer"
    case hydration = "Hydration Hero"
    case movement = "Movement Master"
    case gratitude = "Gratitude Practice"

    var icon: String {
        switch self {
        case .breathing: return "wind"
        case .logging: return "pencil.and.list.clipboard"
        case .savings: return "dollarsign.circle"
        case .health: return "heart.text.square"
        case .letter: return "envelope"
        case .hydration: return "drop.fill"
        case .movement: return "figure.walk"
        case .gratitude: return "star.fill"
        }
    }

    var description: String {
        switch self {
        case .breathing: return "Complete a 2-minute breathing exercise"
        case .logging: return "Log 3 cravings with triggers identified"
        case .savings: return "Check your savings and set a reward goal"
        case .health: return "Read about your next health milestone"
        case .letter: return "Write a note to your future self"
        case .hydration: return "Drink 8 glasses of water today"
        case .movement: return "Take a 10-minute walk"
        case .gratitude: return "Write 3 things you're grateful for"
        }
    }

    var xpReward: Int {
        switch self {
        case .breathing: return 25
        case .logging: return 50
        case .savings: return 20
        case .health: return 30
        case .letter: return 40
        case .hydration: return 35
        case .movement: return 45
        case .gratitude: return 30
        }
    }
}

@Model
final class DailyChallenge {
    var id: UUID
    var type: String // Store as String for SwiftData
    var date: Date
    var completed: Bool
    var completedAt: Date?
    var xpAwarded: Int

    var challengeType: ChallengeType {
        get { ChallengeType(rawValue: type) ?? .breathing }
        set { type = newValue.rawValue }
    }

    var title: String {
        challengeType.rawValue
    }

    var challengeDescription: String {
        challengeType.description
    }

    var icon: String {
        challengeType.icon
    }

    init(type: ChallengeType, date: Date = Date()) {
        self.id = UUID()
        self.type = type.rawValue
        self.date = Calendar.current.startOfDay(for: date)
        self.completed = false
        self.completedAt = nil
        self.xpAwarded = type.xpReward
    }

    func complete() {
        guard !completed else { return }
        completed = true
        completedAt = Date()
    }
}
