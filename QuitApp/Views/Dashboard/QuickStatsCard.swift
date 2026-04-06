import SwiftUI

struct QuickStatsCard: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Quick Stats")
                    .font(AppFonts.headline)
                    .foregroundColor(.white)

                Spacer()

                if let profile = appState.userProfile {
                    Text("Day \(profile.daysSinceQuit + 1)")
                        .font(AppFonts.subheadline)
                        .foregroundColor(.orange)
                }
            }

            if let profile = appState.userProfile {
                HStack(spacing: 20) {
                    QuickStatItem(
                        icon: "dollarsign.circle.fill",
                        value: profile.moneySaved.currencyFormatted,
                        label: "Saved",
                        color: .green
                    )

                    Divider()
                        .frame(height: 40)
                        .background(Color.gray.opacity(0.3))

                    QuickStatItem(
                        icon: "nosign",
                        value: "\(profile.cigarettesAvoided)",
                        label: "Avoided",
                        color: .red
                    )

                    Divider()
                        .frame(height: 40)
                        .background(Color.gray.opacity(0.3))

                    QuickStatItem(
                        icon: "heart.fill",
                        value: profile.lifeRegainedFormatted,
                        label: "Life",
                        color: .pink
                    )
                }
            }
        }
        .padding(20)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

struct QuickStatItem: View {
    let icon: String
    let value: String
    let label: String
    let color: Color

    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 20))
                .foregroundColor(color)

            Text(value)
                .font(AppFonts.headline)
                .foregroundColor(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.7)

            Text(label)
                .font(AppFonts.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
    }
}

struct LiveStatsCard: View {
    @EnvironmentObject var appState: AppState

    @State private var currentTime = Date()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 20) {
            if let profile = appState.userProfile {
                // Money saved - updates live
                LiveStatRow(
                    icon: "dollarsign.circle.fill",
                    title: "Money Saved",
                    value: calculateMoneySaved(profile),
                    color: .green,
                    suffix: ""
                )

                Divider()
                    .background(Color.gray.opacity(0.3))

                // Cigarettes avoided
                LiveStatRow(
                    icon: "nosign",
                    title: "Cigarettes Not Smoked",
                    value: String(format: "%.1f", calculateCigarettes(profile)),
                    color: .red,
                    suffix: ""
                )

                Divider()
                    .background(Color.gray.opacity(0.3))

                // Life regained
                LiveStatRow(
                    icon: "heart.fill",
                    title: "Life Regained",
                    value: calculateLifeRegained(profile),
                    color: .pink,
                    suffix: ""
                )

                Divider()
                    .background(Color.gray.opacity(0.3))

                // Tar avoided
                LiveStatRow(
                    icon: "drop.fill",
                    title: "Tar Avoided",
                    value: String(format: "%.1f", calculateTarAvoided(profile)),
                    color: .brown,
                    suffix: "mg"
                )
            }
        }
        .padding(20)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .onReceive(timer) { _ in
            currentTime = Date()
        }
    }

    private func calculateMoneySaved(_ profile: UserProfile) -> String {
        let secondsSinceQuit = currentTime.timeIntervalSince(profile.quitDate)
        let daysExact = secondsSinceQuit / 86400
        let cigarettesAvoided = daysExact * Double(profile.dailyConsumption)
        let costPerCigarette = profile.costPerPack / Double(profile.packSize)
        let saved = cigarettesAvoided * costPerCigarette
        return saved.currencyFormatted
    }

    private func calculateCigarettes(_ profile: UserProfile) -> Double {
        let secondsSinceQuit = currentTime.timeIntervalSince(profile.quitDate)
        let daysExact = secondsSinceQuit / 86400
        return daysExact * Double(profile.dailyConsumption)
    }

    private func calculateLifeRegained(_ profile: UserProfile) -> String {
        let cigarettes = calculateCigarettes(profile)
        let minutes = cigarettes * 11 // 11 minutes per cigarette
        let hours = Int(minutes / 60)
        let days = hours / 24
        let remainingHours = hours % 24

        if days > 0 {
            return "\(days)d \(remainingHours)h"
        } else {
            return "\(hours)h \(Int(minutes) % 60)m"
        }
    }

    private func calculateTarAvoided(_ profile: UserProfile) -> Double {
        // Average cigarette has ~10mg of tar
        return calculateCigarettes(profile) * 10
    }
}

struct LiveStatRow: View {
    let icon: String
    let title: String
    let value: String
    let color: Color
    let suffix: String

    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
                .frame(width: 40)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(AppFonts.subheadline)
                    .foregroundColor(.gray)

                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(value)
                        .font(AppFonts.title2)
                        .foregroundColor(.white)
                        .contentTransition(.numericText())

                    if !suffix.isEmpty {
                        Text(suffix)
                            .font(AppFonts.subheadline)
                            .foregroundColor(.gray)
                    }
                }
            }

            Spacer()
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        QuickStatsCard()
        LiveStatsCard()
    }
    .padding()
    .environmentObject(AppState())
    .preferredColorScheme(.dark)
}
