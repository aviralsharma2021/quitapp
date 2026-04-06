import SwiftUI

struct DashboardView: View {
    @EnvironmentObject var appState: AppState

    @State private var showContent = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Hero Section - Level & Time
                    heroSection
                        .offset(y: showContent ? 0 : 20)
                        .opacity(showContent ? 1 : 0)

                    // Quick Stats Grid
                    quickStatsGrid
                        .offset(y: showContent ? 0 : 30)
                        .opacity(showContent ? 1 : 0)

                    // Streak Card
                    if let profile = appState.userProfile {
                        StreakCard(
                            currentStreak: profile.currentStreak,
                            longestStreak: profile.longestStreak,
                            shields: profile.streakShields
                        )
                        .padding(.horizontal)
                        .offset(y: showContent ? 0 : 40)
                        .opacity(showContent ? 1 : 0)
                    }

                    // Today's Challenges
                    todaysChallengesSection
                        .offset(y: showContent ? 0 : 50)
                        .opacity(showContent ? 1 : 0)

                    // Next Milestone Preview
                    nextMilestoneSection
                        .offset(y: showContent ? 0 : 60)
                        .opacity(showContent ? 1 : 0)

                    Spacer(minLength: 120)
                }
                .padding(.top, 16)
            }
            .background(Color.black)
            .navigationTitle("Dashboard")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gearshape.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1)) {
                showContent = true
            }
        }
    }

    // MARK: - Hero Section

    private var heroSection: some View {
        VStack(spacing: 20) {
            // Level Progress Ring
            if let profile = appState.userProfile {
                ZStack {
                    LevelProgressRing(
                        level: profile.currentLevel,
                        xpProgress: profile.xpProgress,
                        size: 160
                    )
                }

                Text(profile.levelTitle)
                    .font(AppFonts.headline)
                    .foregroundColor(AppColors.levelColor(for: profile.currentLevel))

                // Live Time Counter
                VStack(spacing: 8) {
                    Text("SMOKE FREE FOR")
                        .font(AppFonts.caption)
                        .foregroundColor(.gray)
                        .tracking(2)

                    if profile.quitDate <= Date() {
                        TimerDisplay(startDate: profile.quitDate)
                    } else {
                        VStack(spacing: 4) {
                            Text("Starting Soon")
                                .font(AppFonts.title2)
                                .foregroundColor(.white)
                            Text("Quit date: \(profile.quitDate.formatted(as: .medium))")
                                .font(AppFonts.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.top, 8)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color(.systemGray6).opacity(0.5))
        )
        .padding(.horizontal)
    }

    // MARK: - Quick Stats Grid

    private var quickStatsGrid: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 12) {
            if let profile = appState.userProfile {
                StatCard(
                    icon: "dollarsign.circle.fill",
                    title: "Money Saved",
                    value: profile.moneySaved.currencyFormatted,
                    iconColor: .green
                )

                StatCard(
                    icon: "nosign",
                    title: "Cigarettes Avoided",
                    value: "\(profile.cigarettesAvoided)",
                    iconColor: .red
                )

                StatCard(
                    icon: "heart.fill",
                    title: "Life Regained",
                    value: profile.lifeRegainedFormatted,
                    iconColor: .pink
                )

                StatCard(
                    icon: "trophy.fill",
                    title: "Cravings Resisted",
                    value: "\(profile.totalCravingsResisted)",
                    iconColor: .yellow
                )
            }
        }
        .padding(.horizontal)
    }

    // MARK: - Today's Challenges

    private var todaysChallengesSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Today's Challenges")
                    .font(AppFonts.headline)
                    .foregroundColor(.white)

                Spacer()

                Text("\(completedChallenges)/\(appState.todaysChallenges.count)")
                    .font(AppFonts.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.horizontal)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(appState.todaysChallenges, id: \.id) { challenge in
                        ChallengeCard(challenge: challenge) {
                            appState.completeChallenge(challenge)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }

    private var completedChallenges: Int {
        appState.todaysChallenges.filter { $0.completed }.count
    }

    // MARK: - Next Milestone

    private var nextMilestoneSection: some View {
        Group {
            if let nextAchievement = appState.nextAchievement,
               let profile = appState.userProfile {
                NextMilestoneCard(
                    achievement: nextAchievement,
                    timeSinceQuit: profile.timeSinceQuit
                )
                .padding(.horizontal)
            }
        }
    }
}

// MARK: - Challenge Card

struct ChallengeCard: View {
    let challenge: DailyChallenge
    let onComplete: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: challenge.icon)
                    .font(.system(size: 20))
                    .foregroundStyle(challenge.completed ? Color.green : AppColors.gradient)

                Spacer()

                if challenge.completed {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                } else {
                    Text("+\(challenge.xpAwarded) XP")
                        .font(AppFonts.caption)
                        .foregroundColor(.orange)
                }
            }

            Text(challenge.title)
                .font(AppFonts.headline)
                .foregroundColor(challenge.completed ? .gray : .white)

            Text(challenge.challengeDescription)
                .font(AppFonts.caption)
                .foregroundColor(.gray)
                .lineLimit(2)

            if !challenge.completed {
                Button(action: onComplete) {
                    Text("Complete")
                        .font(AppFonts.caption)
                        .foregroundColor(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(AppColors.gradient)
                        .clipShape(Capsule())
                }
            }
        }
        .padding(16)
        .frame(width: 180)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .opacity(challenge.completed ? 0.7 : 1)
    }
}

// MARK: - Next Milestone Card

struct NextMilestoneCard: View {
    let achievement: Achievement
    let timeSinceQuit: TimeInterval

    var progress: Double {
        min(timeSinceQuit / achievement.requiredSeconds, 1.0)
    }

    var timeRemaining: TimeInterval {
        max(0, achievement.requiredSeconds - timeSinceQuit)
    }

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Next Milestone")
                        .font(AppFonts.caption)
                        .foregroundColor(.gray)

                    Text(achievement.title)
                        .font(AppFonts.headline)
                        .foregroundColor(.white)
                }

                Spacer()

                ZStack {
                    Circle()
                        .fill(Color(.systemGray5))
                        .frame(width: 50, height: 50)

                    Image(systemName: achievement.iconName)
                        .font(.system(size: 24))
                        .foregroundStyle(AppColors.gradient)
                }
            }

            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color(.systemGray5))
                        .frame(height: 8)

                    Capsule()
                        .fill(AppColors.gradient)
                        .frame(width: geometry.size.width * progress, height: 8)
                }
            }
            .frame(height: 8)

            HStack {
                Text(achievement.achievementDescription)
                    .font(AppFonts.caption)
                    .foregroundColor(.gray)

                Spacer()

                if timeRemaining > 0 {
                    Text(timeRemaining.compactDuration + " to go")
                        .font(AppFonts.caption)
                        .foregroundColor(.orange)
                } else {
                    Text("Unlocking...")
                        .font(AppFonts.caption)
                        .foregroundColor(.green)
                }
            }
        }
        .padding(16)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Settings View (Placeholder)

struct SettingsView: View {
    @EnvironmentObject var appState: AppState
    @State private var showResetConfirmation = false

    var body: some View {
        List {
            Section("Profile") {
                if let profile = appState.userProfile {
                    HStack {
                        Text("Quit Date")
                        Spacer()
                        Text(profile.quitDate.formatted(as: .medium))
                            .foregroundColor(.gray)
                    }

                    HStack {
                        Text("Product Type")
                        Spacer()
                        Text(profile.productTypeEnum.rawValue)
                            .foregroundColor(.gray)
                    }

                    HStack {
                        Text("Daily Consumption")
                        Spacer()
                        Text("\(profile.dailyConsumption)")
                            .foregroundColor(.gray)
                    }
                }
            }

            Section("NRT Tracking") {
                NavigationLink(destination: NRTTrackerView()) {
                    Label("Manage NRT Products", systemImage: "pills.fill")
                }
            }

            Section("About") {
                HStack {
                    Text("Version")
                    Spacer()
                    Text("1.0.0")
                        .foregroundColor(.gray)
                }
            }

            Section {
                Button(role: .destructive) {
                    showResetConfirmation = true
                } label: {
                    Text("Reset All Data")
                }
            }
        }
        .navigationTitle("Settings")
        .alert("Reset All Data?", isPresented: $showResetConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                // Reset logic would go here
            }
        } message: {
            Text("This will delete all your progress and cannot be undone.")
        }
    }
}

#Preview {
    DashboardView()
        .environmentObject(AppState())
        .preferredColorScheme(.dark)
}
