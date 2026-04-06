import Foundation
import SwiftData

@Model
final class Achievement {
    var id: String
    var title: String
    var achievementDescription: String
    var iconName: String
    var requiredSeconds: Double // seconds since quit
    var xpReward: Int
    var unlocked: Bool
    var unlockedDate: Date?
    var category: String

    init(
        id: String,
        title: String,
        description: String,
        iconName: String,
        requiredSeconds: Double,
        xpReward: Int,
        category: String = "health"
    ) {
        self.id = id
        self.title = title
        self.achievementDescription = description
        self.iconName = iconName
        self.requiredSeconds = requiredSeconds
        self.xpReward = xpReward
        self.unlocked = false
        self.unlockedDate = nil
        self.category = category
    }

    func unlock() {
        guard !unlocked else { return }
        unlocked = true
        unlockedDate = Date()
    }
}

// MARK: - Health Milestones

struct HealthMilestones {
    static let all: [(id: String, title: String, description: String, icon: String, seconds: Double, xp: Int, healthBenefit: String)] = [
        (
            id: "20min",
            title: "Heart Whisperer",
            description: "20 minutes smoke-free",
            icon: "heart.fill",
            seconds: 20 * 60,
            xp: 50,
            healthBenefit: "Your heart rate and blood pressure are starting to drop back to normal levels."
        ),
        (
            id: "8hours",
            title: "Oxygen Rising",
            description: "8 hours smoke-free",
            icon: "lungs.fill",
            seconds: 8 * 3600,
            xp: 100,
            healthBenefit: "Carbon monoxide levels in your blood drop by half. Oxygen levels return to normal."
        ),
        (
            id: "24hours",
            title: "Clean Blood",
            description: "24 hours smoke-free",
            icon: "drop.fill",
            seconds: 24 * 3600,
            xp: 200,
            healthBenefit: "Carbon monoxide is eliminated from your body. Your lungs start to clear out mucus."
        ),
        (
            id: "48hours",
            title: "Taste Awakening",
            description: "48 hours smoke-free",
            icon: "mouth.fill",
            seconds: 48 * 3600,
            xp: 300,
            healthBenefit: "There's no nicotine left in your body. Your sense of taste and smell are improving."
        ),
        (
            id: "72hours",
            title: "Peak Survivor",
            description: "72 hours smoke-free",
            icon: "mountain.2.fill",
            seconds: 72 * 3600,
            xp: 500,
            healthBenefit: "You've survived peak withdrawal! Breathing becomes easier as bronchial tubes relax."
        ),
        (
            id: "1week",
            title: "Habit Breaker",
            description: "1 week smoke-free",
            icon: "star.fill",
            seconds: 7 * 24 * 3600,
            xp: 750,
            healthBenefit: "Your body is adjusting to being nicotine-free. Energy levels are improving."
        ),
        (
            id: "2weeks",
            title: "Circulation Hero",
            description: "2 weeks smoke-free",
            icon: "arrow.circlepath",
            seconds: 14 * 24 * 3600,
            xp: 1000,
            healthBenefit: "Your circulation is significantly improving. Walking and exercise become easier."
        ),
        (
            id: "1month",
            title: "Lung Regenerator",
            description: "1 month smoke-free",
            icon: "leaf.fill",
            seconds: 30 * 24 * 3600,
            xp: 1500,
            healthBenefit: "Lung function is increasing. Cilia in your lungs are regrowing, reducing infection risk."
        ),
        (
            id: "3months",
            title: "Heart Guardian",
            description: "3 months smoke-free",
            icon: "shield.fill",
            seconds: 90 * 24 * 3600,
            xp: 2500,
            healthBenefit: "Your lung function has improved by up to 10%. Heart attack risk is starting to drop."
        ),
        (
            id: "6months",
            title: "Breath Master",
            description: "6 months smoke-free",
            icon: "wind",
            seconds: 180 * 24 * 3600,
            xp: 4000,
            healthBenefit: "Coughing, wheezing, and breathing problems are dramatically reduced."
        ),
        (
            id: "1year",
            title: "Phoenix",
            description: "1 year smoke-free",
            icon: "flame.fill",
            seconds: 365 * 24 * 3600,
            xp: 7500,
            healthBenefit: "Your risk of coronary heart disease is now HALF that of a smoker!"
        ),
        (
            id: "5years",
            title: "Immortal",
            description: "5 years smoke-free",
            icon: "crown.fill",
            seconds: 5 * 365 * 24 * 3600,
            xp: 25000,
            healthBenefit: "Your stroke risk equals that of a non-smoker. Mouth, throat, and esophageal cancer risks are halved."
        )
    ]

    static func createAchievements() -> [Achievement] {
        return all.map { milestone in
            Achievement(
                id: milestone.id,
                title: milestone.title,
                description: milestone.description,
                iconName: milestone.icon,
                requiredSeconds: milestone.seconds,
                xpReward: milestone.xp,
                category: "health"
            )
        }
    }

    static func healthBenefit(for id: String) -> String {
        all.first { $0.id == id }?.healthBenefit ?? ""
    }
}
