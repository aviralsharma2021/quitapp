import SwiftUI

struct AchievementsGalleryView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedAchievement: Achievement?

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Stats header
                    achievementStatsHeader
                        .padding(.horizontal)

                    // Grid of achievements
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(appState.achievements, id: \.id) { achievement in
                            AchievementCard(achievement: achievement)
                                .onTapGesture {
                                    if achievement.unlocked {
                                        selectedAchievement = achievement
                                    }
                                }
                        }
                    }
                    .padding(.horizontal)

                    Spacer(minLength: 120)
                }
                .padding(.top, 16)
            }
            .background(Color.black)
            .navigationTitle("Achievements")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(item: $selectedAchievement) { achievement in
                AchievementDetailSheet(achievement: achievement)
                    .presentationDetents([.medium])
                    .presentationDragIndicator(.visible)
            }
        }
    }

    private var achievementStatsHeader: some View {
        HStack(spacing: 20) {
            VStack {
                Text("\(unlockedCount)")
                    .font(AppFonts.title)
                    .foregroundColor(.orange)

                Text("Unlocked")
                    .font(AppFonts.caption)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity)

            Divider()
                .frame(height: 40)
                .background(Color.gray.opacity(0.3))

            VStack {
                Text("\(lockedCount)")
                    .font(AppFonts.title)
                    .foregroundColor(.gray)

                Text("Locked")
                    .font(AppFonts.caption)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity)

            Divider()
                .frame(height: 40)
                .background(Color.gray.opacity(0.3))

            VStack {
                Text("\(totalXP)")
                    .font(AppFonts.title)
                    .foregroundColor(.yellow)

                Text("XP Earned")
                    .font(AppFonts.caption)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity)
        }
        .padding(20)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var unlockedCount: Int {
        appState.achievements.filter { $0.unlocked }.count
    }

    private var lockedCount: Int {
        appState.achievements.filter { !$0.unlocked }.count
    }

    private var totalXP: Int {
        appState.achievements
            .filter { $0.unlocked }
            .reduce(0) { $0 + $1.xpReward }
    }
}

struct AchievementCard: View {
    let achievement: Achievement

    var body: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(achievement.unlocked ? AppColors.gradient : LinearGradient(colors: [Color(.systemGray5)], startPoint: .top, endPoint: .bottom))
                    .frame(width: 60, height: 60)

                Image(systemName: achievement.iconName)
                    .font(.system(size: 24))
                    .foregroundColor(achievement.unlocked ? .white : .gray)

                if !achievement.unlocked {
                    Circle()
                        .fill(Color.black.opacity(0.5))
                        .frame(width: 60, height: 60)

                    Image(systemName: "lock.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                }
            }

            Text(achievement.title)
                .font(AppFonts.caption)
                .foregroundColor(achievement.unlocked ? .white : .gray)
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .opacity(achievement.unlocked ? 1 : 0.6)
    }
}

struct AchievementDetailSheet: View {
    let achievement: Achievement
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 24) {
            // Header
            ZStack {
                Circle()
                    .fill(AppColors.gradient)
                    .frame(width: 100, height: 100)
                    .shadow(color: .orange.opacity(0.5), radius: 20)

                Image(systemName: achievement.iconName)
                    .font(.system(size: 44))
                    .foregroundColor(.white)
            }
            .padding(.top, 32)

            VStack(spacing: 8) {
                Text(achievement.title)
                    .font(AppFonts.title)
                    .foregroundColor(.white)

                Text(achievement.achievementDescription)
                    .font(AppFonts.subheadline)
                    .foregroundColor(.gray)
            }

            // Health benefit
            VStack(alignment: .leading, spacing: 8) {
                Text("Health Benefit")
                    .font(AppFonts.caption)
                    .foregroundColor(.gray)

                Text(HealthMilestones.healthBenefit(for: achievement.id))
                    .font(AppFonts.body)
                    .foregroundColor(.white)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal)

            // Details
            HStack(spacing: 32) {
                VStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text("+\(achievement.xpReward) XP")
                        .font(AppFonts.headline)
                        .foregroundColor(.white)
                }

                if let unlockedDate = achievement.unlockedDate {
                    VStack {
                        Image(systemName: "calendar")
                            .foregroundColor(.green)
                        Text(unlockedDate.formatted(as: .medium))
                            .font(AppFonts.headline)
                            .foregroundColor(.white)
                    }
                }
            }

            Spacer()

            Button(action: { dismiss() }) {
                Text("Close")
                    .font(AppFonts.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(Color(.systemGray5))
                    .clipShape(Capsule())
            }
            .padding(.horizontal)
            .padding(.bottom, 24)
        }
        .background(Color.black)
    }
}

extension Achievement: Identifiable { }

#Preview {
    AchievementsGalleryView()
        .environmentObject(AppState())
        .preferredColorScheme(.dark)
}
