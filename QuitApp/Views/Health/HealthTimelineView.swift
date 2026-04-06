import SwiftUI

struct HealthTimelineView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    // Header Stats
                    healthHeaderCard
                        .padding(.horizontal)

                    // Timeline
                    VStack(spacing: 0) {
                        ForEach(Array(HealthMilestones.all.enumerated()), id: \.element.id) { index, milestone in
                            let isUnlocked = isMilestoneUnlocked(milestone.id)
                            let isNext = isNextMilestone(milestone.id)

                            MilestoneRow(
                                milestone: milestone,
                                isUnlocked: isUnlocked,
                                isNext: isNext,
                                progress: progressForMilestone(milestone),
                                isLast: index == HealthMilestones.all.count - 1
                            )
                        }
                    }
                    .padding(.horizontal)

                    Spacer(minLength: 120)
                }
                .padding(.top, 16)
            }
            .background(Color.black)
            .navigationTitle("Health Timeline")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private var healthHeaderCard: some View {
        VStack(spacing: 16) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Your Body is Healing")
                        .font(AppFonts.headline)
                        .foregroundColor(.white)

                    Text("Watch your health improve over time")
                        .font(AppFonts.caption)
                        .foregroundColor(.gray)
                }

                Spacer()

                // Unlocked count
                VStack {
                    Text("\(unlockedCount)")
                        .font(AppFonts.title)
                        .foregroundColor(.green)

                    Text("of \(HealthMilestones.all.count)")
                        .font(AppFonts.caption)
                        .foregroundColor(.gray)
                }
            }

            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color(.systemGray5))
                        .frame(height: 8)

                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [.green, .mint],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geometry.size.width * overallProgress, height: 8)
                }
            }
            .frame(height: 8)
        }
        .padding(20)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var unlockedCount: Int {
        appState.achievements.filter { $0.unlocked }.count
    }

    private var overallProgress: Double {
        guard let profile = appState.userProfile else { return 0 }
        let timeSinceQuit = profile.timeSinceQuit
        let lastMilestone = HealthMilestones.all.last!.seconds
        return min(timeSinceQuit / lastMilestone, 1.0)
    }

    private func isMilestoneUnlocked(_ id: String) -> Bool {
        appState.achievements.first { $0.id == id }?.unlocked ?? false
    }

    private func isNextMilestone(_ id: String) -> Bool {
        guard let nextAchievement = appState.nextAchievement else { return false }
        return nextAchievement.id == id
    }

    private func progressForMilestone(_ milestone: (id: String, title: String, description: String, icon: String, seconds: Double, xp: Int, healthBenefit: String)) -> Double {
        guard let profile = appState.userProfile else { return 0 }
        let timeSinceQuit = profile.timeSinceQuit
        return min(timeSinceQuit / milestone.seconds, 1.0)
    }
}

struct MilestoneRow: View {
    let milestone: (id: String, title: String, description: String, icon: String, seconds: Double, xp: Int, healthBenefit: String)
    let isUnlocked: Bool
    let isNext: Bool
    let progress: Double
    let isLast: Bool

    @State private var isExpanded = false

    var timeLabel: String {
        let seconds = milestone.seconds
        if seconds < 3600 {
            return "\(Int(seconds / 60)) min"
        } else if seconds < 86400 {
            return "\(Int(seconds / 3600)) hours"
        } else if seconds < 604800 {
            return "\(Int(seconds / 86400)) days"
        } else if seconds < 2592000 {
            return "\(Int(seconds / 604800)) weeks"
        } else if seconds < 31536000 {
            return "\(Int(seconds / 2592000)) months"
        } else {
            return "\(Int(seconds / 31536000)) years"
        }
    }

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            // Timeline line and dot
            VStack(spacing: 0) {
                // Dot
                ZStack {
                    Circle()
                        .fill(isUnlocked ? Color.green : (isNext ? Color.orange : Color(.systemGray5)))
                        .frame(width: 20, height: 20)

                    if isUnlocked {
                        Image(systemName: "checkmark")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                    } else if isNext {
                        Circle()
                            .fill(Color.orange)
                            .frame(width: 8, height: 8)
                    }
                }

                // Line
                if !isLast {
                    Rectangle()
                        .fill(isUnlocked ? Color.green : Color(.systemGray5))
                        .frame(width: 2)
                        .frame(maxHeight: .infinity)
                }
            }
            .frame(width: 20)

            // Content
            VStack(alignment: .leading, spacing: 12) {
                Button(action: {
                    withAnimation(.spring(response: 0.3)) {
                        isExpanded.toggle()
                    }
                }) {
                    HStack {
                        // Icon
                        ZStack {
                            Circle()
                                .fill(isUnlocked ? Color.green.opacity(0.2) : Color(.systemGray5))
                                .frame(width: 44, height: 44)

                            Image(systemName: milestone.icon)
                                .font(.system(size: 20))
                                .foregroundColor(isUnlocked ? .green : .gray)
                        }

                        VStack(alignment: .leading, spacing: 4) {
                            Text(milestone.title)
                                .font(AppFonts.headline)
                                .foregroundColor(isUnlocked ? .white : .gray)

                            Text(timeLabel)
                                .font(AppFonts.caption)
                                .foregroundColor(isUnlocked ? .green : .gray)
                        }

                        Spacer()

                        if !isUnlocked && isNext {
                            Text("\(Int(progress * 100))%")
                                .font(AppFonts.caption)
                                .foregroundColor(.orange)
                        }

                        Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                            .font(.system(size: 12))
                            .foregroundColor(.gray)
                    }
                }
                .buttonStyle(.plain)

                // Expanded content
                if isExpanded {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(milestone.healthBenefit)
                            .font(AppFonts.subheadline)
                            .foregroundColor(.white)
                            .fixedSize(horizontal: false, vertical: true)

                        HStack {
                            Label("+\(milestone.xp) XP", systemImage: "star.fill")
                                .font(AppFonts.caption)
                                .foregroundColor(.yellow)

                            Spacer()

                            if isUnlocked {
                                Label("Achieved", systemImage: "checkmark.seal.fill")
                                    .font(AppFonts.caption)
                                    .foregroundColor(.green)
                            }
                        }

                        if !isUnlocked && isNext {
                            // Progress bar
                            GeometryReader { geometry in
                                ZStack(alignment: .leading) {
                                    Capsule()
                                        .fill(Color(.systemGray5))
                                        .frame(height: 6)

                                    Capsule()
                                        .fill(Color.orange)
                                        .frame(width: geometry.size.width * progress, height: 6)
                                }
                            }
                            .frame(height: 6)
                        }
                    }
                    .padding(12)
                    .background(Color(.systemGray6))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding(.bottom, isLast ? 0 : 24)
        }
    }
}

#Preview {
    HealthTimelineView()
        .environmentObject(AppState())
        .preferredColorScheme(.dark)
}
