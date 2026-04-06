import Foundation
import SwiftUI
import SwiftData
import Combine

@MainActor
class AppState: ObservableObject {
    @Published var userProfile: UserProfile?
    @Published var hasCompletedOnboarding: Bool = false
    @Published var achievements: [Achievement] = []
    @Published var todaysChallenges: [DailyChallenge] = []
    @Published var recentCravings: [Craving] = []
    @Published var nrtProducts: [NRTProduct] = []

    var modelContext: ModelContext?

    private var timer: Timer?
    @Published var currentTime: Date = Date()

    init() {
        // Check if onboarding was completed
        hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")

        // Start timer for live updates
        startTimer()
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.currentTime = Date()
                self?.checkAchievements()
                self?.updateStreak()
            }
        }
    }

    func loadUserProfile() {
        guard let context = modelContext else { return }

        let descriptor = FetchDescriptor<UserProfile>()
        do {
            let profiles = try context.fetch(descriptor)
            userProfile = profiles.first
            if userProfile != nil {
                loadAchievements()
                loadTodaysChallenges()
                loadRecentCravings()
                loadNRTProducts()
            }
        } catch {
            print("Failed to load user profile: \(error)")
        }
    }

    func createUserProfile(
        quitDate: Date,
        productType: ProductType,
        dailyConsumption: Int,
        costPerPack: Double,
        packSize: Int
    ) {
        guard let context = modelContext else { return }

        let profile = UserProfile(
            quitDate: quitDate,
            productType: productType,
            dailyConsumption: dailyConsumption,
            costPerPack: costPerPack,
            packSize: packSize
        )

        context.insert(profile)
        userProfile = profile

        // Create initial achievements
        let achievements = HealthMilestones.createAchievements()
        for achievement in achievements {
            context.insert(achievement)
        }

        // Create today's challenges
        generateDailyChallenges()

        do {
            try context.save()
            hasCompletedOnboarding = true
            UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
            loadAchievements()
            loadTodaysChallenges()
        } catch {
            print("Failed to save profile: \(error)")
        }
    }

    // MARK: - Achievements

    func loadAchievements() {
        guard let context = modelContext else { return }

        let descriptor = FetchDescriptor<Achievement>(
            sortBy: [SortDescriptor(\.requiredSeconds)]
        )
        do {
            achievements = try context.fetch(descriptor)
        } catch {
            print("Failed to load achievements: \(error)")
        }
    }

    func checkAchievements() {
        guard let profile = userProfile else { return }

        let timeSinceQuit = profile.timeSinceQuit

        for achievement in achievements where !achievement.unlocked {
            if timeSinceQuit >= achievement.requiredSeconds {
                achievement.unlock()
                profile.addXP(achievement.xpReward)

                // Trigger haptic and notification
                notifyAchievementUnlocked(achievement)
            }
        }

        try? modelContext?.save()
    }

    private func notifyAchievementUnlocked(_ achievement: Achievement) {
        // Haptic feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)

        // Could also trigger a local notification here
    }

    var nextAchievement: Achievement? {
        achievements.first { !$0.unlocked }
    }

    var unlockedAchievements: [Achievement] {
        achievements.filter { $0.unlocked }
    }

    // MARK: - Daily Challenges

    func loadTodaysChallenges() {
        guard let context = modelContext else { return }

        let today = Calendar.current.startOfDay(for: Date())
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: today)!

        var descriptor = FetchDescriptor<DailyChallenge>(
            predicate: #Predicate { $0.date >= today && $0.date < tomorrow }
        )
        descriptor.sortBy = [SortDescriptor(\.type)]

        do {
            todaysChallenges = try context.fetch(descriptor)
            if todaysChallenges.isEmpty {
                generateDailyChallenges()
                todaysChallenges = try context.fetch(descriptor)
            }
        } catch {
            print("Failed to load challenges: \(error)")
        }
    }

    func generateDailyChallenges() {
        guard let context = modelContext else { return }

        // Pick 3 random challenges for today
        let allTypes = ChallengeType.allCases.shuffled()
        let selectedTypes = Array(allTypes.prefix(3))

        for type in selectedTypes {
            let challenge = DailyChallenge(type: type)
            context.insert(challenge)
        }

        try? context.save()
    }

    func completeChallenge(_ challenge: DailyChallenge) {
        challenge.complete()
        userProfile?.addXP(challenge.xpAwarded)
        try? modelContext?.save()

        // Haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
    }

    // MARK: - Cravings

    func loadRecentCravings() {
        guard let context = modelContext else { return }

        var descriptor = FetchDescriptor<Craving>(
            sortBy: [SortDescriptor(\.timestamp, order: .reverse)]
        )
        descriptor.fetchLimit = 50

        do {
            recentCravings = try context.fetch(descriptor)
        } catch {
            print("Failed to load cravings: \(error)")
        }
    }

    func logCraving(
        intensity: Int,
        trigger: CravingTrigger,
        copingUsed: CopingTechnique?,
        resisted: Bool,
        duration: Double?,
        notes: String?
    ) {
        guard let context = modelContext else { return }

        let craving = Craving(
            intensity: intensity,
            trigger: trigger,
            copingUsed: copingUsed,
            resisted: resisted,
            duration: duration,
            notes: notes
        )

        context.insert(craving)

        if resisted {
            userProfile?.totalCravingsResisted += 1
            userProfile?.addXP(20 + (intensity * 5)) // More XP for resisting stronger cravings
        }

        try? context.save()
        loadRecentCravings()

        // Haptic feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(resisted ? .success : .warning)
    }

    // MARK: - NRT

    func loadNRTProducts() {
        guard let context = modelContext else { return }

        let descriptor = FetchDescriptor<NRTProduct>(
            predicate: #Predicate { $0.isActive }
        )

        do {
            nrtProducts = try context.fetch(descriptor)
        } catch {
            print("Failed to load NRT products: \(error)")
        }
    }

    func addNRTProduct(_ product: NRTProduct) {
        guard let context = modelContext else { return }
        context.insert(product)
        try? context.save()
        loadNRTProducts()
    }

    func logNRTUsage(product: NRTProduct, quantity: Int, notes: String? = nil) {
        guard let context = modelContext else { return }

        let log = NRTUsageLog(
            productId: product.id,
            quantity: quantity,
            nicotineAmount: product.nicotineContent * Double(quantity),
            cost: product.costPerUnit * Double(quantity),
            notes: notes
        )

        context.insert(log)
        try? context.save()
    }

    func getNRTStats() -> (totalNicotine: Double, totalCost: Double, todayNicotine: Double) {
        guard let context = modelContext else { return (0, 0, 0) }

        let descriptor = FetchDescriptor<NRTUsageLog>()
        do {
            let logs = try context.fetch(descriptor)
            let totalNicotine = logs.reduce(0) { $0 + $1.nicotineAmount }
            let totalCost = logs.reduce(0) { $0 + $1.cost }

            let today = Calendar.current.startOfDay(for: Date())
            let todayLogs = logs.filter { $0.timestamp >= today }
            let todayNicotine = todayLogs.reduce(0) { $0 + $1.nicotineAmount }

            return (totalNicotine, totalCost, todayNicotine)
        } catch {
            return (0, 0, 0)
        }
    }

    // MARK: - Streak

    func updateStreak() {
        guard let profile = userProfile else { return }

        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let lastUpdate = calendar.startOfDay(for: profile.lastStreakUpdate)

        if today > lastUpdate {
            // Check if quit date is before today
            if profile.quitDate <= Date() {
                let daysSinceLastUpdate = calendar.dateComponents([.day], from: lastUpdate, to: today).day ?? 0

                if daysSinceLastUpdate == 1 {
                    // Consecutive day
                    profile.currentStreak += 1
                    if profile.currentStreak > profile.longestStreak {
                        profile.longestStreak = profile.currentStreak
                    }
                    // Streak bonus XP
                    let streakBonus = min(profile.currentStreak * 10, 100)
                    profile.addXP(streakBonus)
                } else if daysSinceLastUpdate > 1 {
                    // Streak broken (unless they have a shield)
                    if profile.streakShields > 0 {
                        profile.streakShields -= 1
                    } else {
                        profile.currentStreak = 1
                    }
                }

                profile.lastStreakUpdate = Date()
                try? modelContext?.save()
            }
        }
    }

    // MARK: - Computed Stats

    var moneySaved: Double {
        userProfile?.moneySaved ?? 0
    }

    var netSavings: Double {
        let saved = moneySaved
        let (_, nrtCost, _) = getNRTStats()
        return saved - nrtCost
    }

    var cigarettesAvoided: Int {
        userProfile?.cigarettesAvoided ?? 0
    }

    var timeSinceQuit: TimeInterval {
        userProfile?.timeSinceQuit ?? 0
    }

    var formattedTimeSinceQuit: String {
        let interval = timeSinceQuit
        let days = Int(interval / 86400)
        let hours = Int((interval.truncatingRemainder(dividingBy: 86400)) / 3600)
        let minutes = Int((interval.truncatingRemainder(dividingBy: 3600)) / 60)
        let seconds = Int(interval.truncatingRemainder(dividingBy: 60))

        if days > 0 {
            return String(format: "%dd %02dh %02dm", days, hours, minutes)
        } else {
            return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        }
    }
}
