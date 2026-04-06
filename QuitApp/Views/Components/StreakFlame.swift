import SwiftUI

struct StreakFlame: View {
    let streak: Int
    var size: CGFloat = 60

    @State private var isAnimating = false

    var flameColor: Color {
        switch streak {
        case 0: return .gray
        case 1...7: return .orange
        case 8...30: return .red
        case 31...90: return .purple
        default: return .blue
        }
    }

    var body: some View {
        ZStack {
            // Glow effect
            Image(systemName: "flame.fill")
                .font(.system(size: size))
                .foregroundColor(flameColor)
                .blur(radius: 20)
                .opacity(streak > 0 ? 0.6 : 0)
                .scaleEffect(isAnimating ? 1.2 : 1.0)

            // Main flame
            Image(systemName: "flame.fill")
                .font(.system(size: size))
                .foregroundStyle(
                    streak > 0 ?
                    LinearGradient(
                        colors: [.yellow, flameColor],
                        startPoint: .bottom,
                        endPoint: .top
                    ) :
                    LinearGradient(colors: [.gray], startPoint: .bottom, endPoint: .top)
                )
                .scaleEffect(isAnimating ? 1.05 : 1.0)

            // Streak number
            if streak > 0 {
                Text("\(streak)")
                    .font(.system(size: size * 0.35, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.3), radius: 2, y: 1)
                    .offset(y: size * 0.1)
            }
        }
        .onAppear {
            if streak > 0 {
                withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                    isAnimating = true
                }
            }
        }
    }
}

struct StreakCard: View {
    let currentStreak: Int
    let longestStreak: Int
    let shields: Int

    var body: some View {
        HStack(spacing: 20) {
            StreakFlame(streak: currentStreak, size: 50)

            VStack(alignment: .leading, spacing: 4) {
                Text("Current Streak")
                    .font(AppFonts.caption)
                    .foregroundColor(.gray)

                Text("\(currentStreak) days")
                    .font(AppFonts.title2)
                    .foregroundColor(.white)

                HStack(spacing: 12) {
                    Label("Best: \(longestStreak)", systemImage: "trophy.fill")
                        .font(AppFonts.caption)
                        .foregroundColor(.yellow)

                    if shields > 0 {
                        Label("\(shields)", systemImage: "shield.fill")
                            .font(AppFonts.caption)
                            .foregroundColor(.blue)
                    }
                }
            }

            Spacer()
        }
        .padding(16)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct StreakMilestone: View {
    let days: Int
    let isAchieved: Bool
    let reward: String

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(isAchieved ? Color.orange : Color(.systemGray5))
                    .frame(width: 50, height: 50)

                if isAchieved {
                    Image(systemName: "checkmark")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                } else {
                    Text("\(days)")
                        .font(AppFonts.headline)
                        .foregroundColor(.gray)
                }
            }

            Text("\(days)d")
                .font(AppFonts.caption)
                .foregroundColor(isAchieved ? .orange : .gray)

            Text(reward)
                .font(.system(size: 10))
                .foregroundColor(.gray)
                .lineLimit(1)
        }
        .frame(width: 60)
    }
}

struct StreakProgress: View {
    let currentStreak: Int

    let milestones = [
        (days: 3, reward: "+50 XP"),
        (days: 7, reward: "Shield"),
        (days: 14, reward: "+200 XP"),
        (days: 30, reward: "Badge"),
        (days: 60, reward: "+500 XP"),
        (days: 90, reward: "Trophy")
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Streak Milestones")
                .font(AppFonts.headline)
                .foregroundColor(.white)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(milestones, id: \.days) { milestone in
                        StreakMilestone(
                            days: milestone.days,
                            isAchieved: currentStreak >= milestone.days,
                            reward: milestone.reward
                        )
                    }
                }
                .padding(.horizontal, 4)
            }
        }
        .padding(16)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    VStack(spacing: 24) {
        HStack(spacing: 20) {
            StreakFlame(streak: 0)
            StreakFlame(streak: 5)
            StreakFlame(streak: 15)
            StreakFlame(streak: 45)
            StreakFlame(streak: 100)
        }

        StreakCard(currentStreak: 12, longestStreak: 45, shields: 2)

        StreakProgress(currentStreak: 12)
    }
    .padding()
    .preferredColorScheme(.dark)
}
