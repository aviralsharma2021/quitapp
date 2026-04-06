import SwiftUI
import Charts

struct StatsView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Overview cards
                    overviewCards
                        .padding(.horizontal)

                    // Craving stats
                    if !appState.recentCravings.isEmpty {
                        cravingStatsSection
                            .padding(.horizontal)
                    }

                    // Money breakdown
                    moneyBreakdownCard
                        .padding(.horizontal)

                    // Health improvements
                    healthImprovementsCard
                        .padding(.horizontal)

                    Spacer(minLength: 120)
                }
                .padding(.top, 16)
            }
            .background(Color.black)
            .navigationTitle("Statistics")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var overviewCards: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            if let profile = appState.userProfile {
                StatCard(
                    icon: "calendar",
                    title: "Days Smoke-Free",
                    value: "\(profile.daysSinceQuit)",
                    iconColor: .blue
                )

                StatCard(
                    icon: "flame.fill",
                    title: "Current Streak",
                    value: "\(profile.currentStreak) days",
                    subtitle: "Best: \(profile.longestStreak)",
                    iconColor: .orange
                )

                StatCard(
                    icon: "star.fill",
                    title: "Current Level",
                    value: "\(profile.currentLevel)",
                    subtitle: profile.levelTitle,
                    iconColor: AppColors.levelColor(for: profile.currentLevel)
                )

                StatCard(
                    icon: "chart.line.uptrend.xyaxis",
                    title: "Total XP",
                    value: "\(profile.currentXP)",
                    iconColor: .yellow
                )
            }
        }
    }

    private var cravingStatsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Craving Insights")
                .font(AppFonts.headline)
                .foregroundColor(.white)

            VStack(spacing: 12) {
                // Craving count
                HStack {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.orange)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Total Cravings Logged")
                            .font(AppFonts.subheadline)
                            .foregroundColor(.gray)

                        Text("\(appState.recentCravings.count)")
                            .font(AppFonts.title2)
                            .foregroundColor(.white)
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 2) {
                        Text("Resisted")
                            .font(AppFonts.caption)
                            .foregroundColor(.gray)

                        Text("\(resistedCount)")
                            .font(AppFonts.headline)
                            .foregroundColor(.green)
                    }
                }

                Divider()
                    .background(Color.gray.opacity(0.3))

                // Most common trigger
                if let topTrigger = mostCommonTrigger {
                    HStack {
                        Image(systemName: topTrigger.icon)
                            .foregroundColor(.blue)

                        VStack(alignment: .leading, spacing: 2) {
                            Text("Most Common Trigger")
                                .font(AppFonts.subheadline)
                                .foregroundColor(.gray)

                            Text(topTrigger.rawValue)
                                .font(AppFonts.headline)
                                .foregroundColor(.white)
                        }

                        Spacer()
                    }
                }

                Divider()
                    .background(Color.gray.opacity(0.3))

                // Average intensity
                HStack {
                    Image(systemName: "gauge")
                        .foregroundColor(.purple)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Average Intensity")
                            .font(AppFonts.subheadline)
                            .foregroundColor(.gray)

                        Text(String(format: "%.1f / 10", averageIntensity))
                            .font(AppFonts.headline)
                            .foregroundColor(.white)
                    }

                    Spacer()
                }
            }
            .padding(16)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }

    private var moneyBreakdownCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Financial Impact")
                .font(AppFonts.headline)
                .foregroundColor(.white)

            VStack(spacing: 12) {
                if let profile = appState.userProfile {
                    // Money saved
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Money Saved from Quitting")
                                .font(AppFonts.subheadline)
                                .foregroundColor(.gray)

                            Text(profile.moneySaved.currencyFormatted)
                                .font(AppFonts.title)
                                .foregroundColor(.green)
                        }

                        Spacer()
                    }

                    Divider()
                        .background(Color.gray.opacity(0.3))

                    // NRT costs
                    let (_, nrtCost, _) = appState.getNRTStats()
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("NRT Costs")
                                .font(AppFonts.subheadline)
                                .foregroundColor(.gray)

                            Text(nrtCost.currencyFormatted)
                                .font(AppFonts.title2)
                                .foregroundColor(.blue)
                        }

                        Spacer()
                    }

                    Divider()
                        .background(Color.gray.opacity(0.3))

                    // Net savings
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Net Savings")
                                .font(AppFonts.subheadline)
                                .foregroundColor(.gray)

                            Text(appState.netSavings.currencyFormatted)
                                .font(AppFonts.title)
                                .foregroundColor(appState.netSavings >= 0 ? .green : .red)
                        }

                        Spacer()

                        if appState.netSavings > 0 {
                            Image(systemName: "arrow.up.right.circle.fill")
                                .font(.system(size: 32))
                                .foregroundColor(.green)
                        }
                    }

                    // Projection
                    let monthlyRate = profile.moneySaved / max(Double(profile.daysSinceQuit), 1) * 30
                    let yearlyRate = monthlyRate * 12

                    Divider()
                        .background(Color.gray.opacity(0.3))

                    VStack(alignment: .leading, spacing: 8) {
                        Text("Projected Savings")
                            .font(AppFonts.caption)
                            .foregroundColor(.gray)

                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text("Per Month")
                                    .font(AppFonts.caption)
                                    .foregroundColor(.gray)
                                Text(monthlyRate.currencyFormatted)
                                    .font(AppFonts.headline)
                                    .foregroundColor(.white)
                            }

                            Spacer()

                            VStack(alignment: .trailing, spacing: 2) {
                                Text("Per Year")
                                    .font(AppFonts.caption)
                                    .foregroundColor(.gray)
                                Text(yearlyRate.currencyFormatted)
                                    .font(AppFonts.headline)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
            }
            .padding(16)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }

    private var healthImprovementsCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Health Improvements")
                .font(AppFonts.headline)
                .foregroundColor(.white)

            VStack(spacing: 12) {
                if let profile = appState.userProfile {
                    // Life regained
                    HStack {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.pink)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Life Regained")
                                .font(AppFonts.subheadline)
                                .foregroundColor(.gray)

                            Text(profile.lifeRegainedFormatted)
                                .font(AppFonts.title2)
                                .foregroundColor(.white)
                        }

                        Spacer()
                    }

                    Divider()
                        .background(Color.gray.opacity(0.3))

                    // Cigarettes avoided
                    HStack {
                        Image(systemName: "nosign")
                            .font(.system(size: 24))
                            .foregroundColor(.red)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Cigarettes Not Smoked")
                                .font(AppFonts.subheadline)
                                .foregroundColor(.gray)

                            Text("\(profile.cigarettesAvoided)")
                                .font(AppFonts.title2)
                                .foregroundColor(.white)
                        }

                        Spacer()
                    }

                    Divider()
                        .background(Color.gray.opacity(0.3))

                    // Tar avoided (approx 10mg per cigarette)
                    let tarAvoided = Double(profile.cigarettesAvoided) * 10
                    HStack {
                        Image(systemName: "drop.fill")
                            .font(.system(size: 24))
                            .foregroundColor(.brown)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Tar Avoided")
                                .font(AppFonts.subheadline)
                                .foregroundColor(.gray)

                            Text(String(format: "%.1f g", tarAvoided / 1000))
                                .font(AppFonts.title2)
                                .foregroundColor(.white)
                        }

                        Spacer()
                    }

                    Divider()
                        .background(Color.gray.opacity(0.3))

                    // CO2 avoided (approx 60mg per cigarette)
                    let co2Avoided = Double(profile.cigarettesAvoided) * 60
                    HStack {
                        Image(systemName: "wind")
                            .font(.system(size: 24))
                            .foregroundColor(.cyan)

                        VStack(alignment: .leading, spacing: 4) {
                            Text("CO₂ Avoided")
                                .font(AppFonts.subheadline)
                                .foregroundColor(.gray)

                            Text(String(format: "%.1f g", co2Avoided / 1000))
                                .font(AppFonts.title2)
                                .foregroundColor(.white)
                        }

                        Spacer()
                    }
                }
            }
            .padding(16)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }

    // MARK: - Computed Properties

    private var resistedCount: Int {
        appState.recentCravings.filter { $0.resisted }.count
    }

    private var mostCommonTrigger: CravingTrigger? {
        let triggers = appState.recentCravings.map { $0.triggerEnum }
        let counts = Dictionary(grouping: triggers) { $0 }
        return counts.max(by: { $0.value.count < $1.value.count })?.key
    }

    private var averageIntensity: Double {
        guard !appState.recentCravings.isEmpty else { return 0 }
        let total = appState.recentCravings.reduce(0) { $0 + $1.intensity }
        return Double(total) / Double(appState.recentCravings.count)
    }
}

#Preview {
    StatsView()
        .environmentObject(AppState())
        .preferredColorScheme(.dark)
}
