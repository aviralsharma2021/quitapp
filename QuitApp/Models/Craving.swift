import Foundation
import SwiftData

enum CravingTrigger: String, Codable, CaseIterable {
    case stress = "Stress"
    case boredom = "Boredom"
    case social = "Social Situation"
    case afterMeal = "After Meal"
    case morning = "Morning Routine"
    case alcohol = "Alcohol"
    case coffee = "Coffee/Tea"
    case driving = "Driving"
    case work = "Work Break"
    case anxiety = "Anxiety"
    case habit = "Habit/Automatic"
    case other = "Other"

    var icon: String {
        switch self {
        case .stress: return "bolt.heart"
        case .boredom: return "clock"
        case .social: return "person.3"
        case .afterMeal: return "fork.knife"
        case .morning: return "sunrise"
        case .alcohol: return "wineglass"
        case .coffee: return "cup.and.saucer"
        case .driving: return "car"
        case .work: return "briefcase"
        case .anxiety: return "brain.head.profile"
        case .habit: return "arrow.clockwise"
        case .other: return "ellipsis.circle"
        }
    }
}

enum CopingTechnique: String, Codable, CaseIterable {
    case breathing = "Deep Breathing"
    case water = "Drink Water"
    case walk = "Take a Walk"
    case delay = "Delay 5 Minutes"
    case distraction = "Distraction"
    case snack = "Healthy Snack"
    case call = "Call Someone"
    case meditation = "Quick Meditation"
    case exercise = "Quick Exercise"
    case gum = "Chew Gum"

    var icon: String {
        switch self {
        case .breathing: return "wind"
        case .water: return "drop"
        case .walk: return "figure.walk"
        case .delay: return "timer"
        case .distraction: return "gamecontroller"
        case .snack: return "carrot"
        case .call: return "phone"
        case .meditation: return "sparkles"
        case .exercise: return "figure.run"
        case .gum: return "mouth"
        }
    }

    var description: String {
        switch self {
        case .breathing: return "Take 10 slow, deep breaths. Inhale for 4 seconds, hold for 4, exhale for 6."
        case .water: return "Drink a full glass of water slowly. This can help reduce the craving intensity."
        case .walk: return "Step outside for a quick 5-minute walk. Change your environment."
        case .delay: return "Tell yourself you'll wait just 5 more minutes. Cravings typically pass in 3-5 minutes."
        case .distraction: return "Do something engaging: play a game, watch a video, text a friend."
        case .snack: return "Eat a healthy snack like carrots, nuts, or fruit to keep your mouth busy."
        case .call: return "Call or text a supportive friend or family member."
        case .meditation: return "Close your eyes and focus on the present moment for 2 minutes."
        case .exercise: return "Do 20 jumping jacks or push-ups to release endorphins."
        case .gum: return "Chew sugar-free gum to satisfy the oral fixation."
        }
    }
}

@Model
final class Craving {
    var id: UUID
    var timestamp: Date
    var intensity: Int // 1-10
    var trigger: String // Store as String for SwiftData
    var copingUsed: String? // Store as String for SwiftData
    var resisted: Bool
    var duration: Double? // seconds until craving passed
    var notes: String?

    var triggerEnum: CravingTrigger {
        get { CravingTrigger(rawValue: trigger) ?? .other }
        set { trigger = newValue.rawValue }
    }

    var copingEnum: CopingTechnique? {
        get { copingUsed.flatMap { CopingTechnique(rawValue: $0) } }
        set { copingUsed = newValue?.rawValue }
    }

    init(
        intensity: Int = 5,
        trigger: CravingTrigger = .stress,
        copingUsed: CopingTechnique? = nil,
        resisted: Bool = true,
        duration: Double? = nil,
        notes: String? = nil
    ) {
        self.id = UUID()
        self.timestamp = Date()
        self.intensity = intensity
        self.trigger = trigger.rawValue
        self.copingUsed = copingUsed?.rawValue
        self.resisted = resisted
        self.duration = duration
        self.notes = notes
    }
}
