import SwiftUI

struct LevelBadge: View {
    let level: Int
    let title: String
    var size: CGFloat = 80

    var badgeColor: Color {
        AppColors.levelColor(for: level)
    }

    var body: some View {
        ZStack {
            // Outer glow
            Circle()
                .fill(badgeColor)
                .frame(width: size, height: size)
                .blur(radius: 15)
                .opacity(0.5)

            // Badge background
            Circle()
                .fill(
                    LinearGradient(
                        colors: [badgeColor, badgeColor.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: size, height: size)

            // Inner circle
            Circle()
                .fill(Color.black.opacity(0.3))
                .frame(width: size * 0.75, height: size * 0.75)

            // Level content
            VStack(spacing: 0) {
                Text("LVL")
                    .font(.system(size: size * 0.12, weight: .medium))
                    .foregroundColor(.white.opacity(0.8))

                Text("\(level)")
                    .font(.system(size: size * 0.35, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }

            // Decorative ring
            Circle()
                .stroke(badgeColor.opacity(0.5), lineWidth: 2)
                .frame(width: size * 0.9, height: size * 0.9)
        }
    }
}

struct LevelCard: View {
    let level: Int
    let title: String
    let xpProgress: Double
    let currentXP: Int
    let xpForNext: Int

    var body: some View {
        HStack(spacing: 16) {
            LevelBadge(level: level, title: title, size: 70)

            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(title)
                        .font(AppFonts.headline)
                        .foregroundColor(.white)

                    Spacer()

                    Text("\(currentXP) / \(xpForNext) XP")
                        .font(AppFonts.caption)
                        .foregroundColor(.gray)
                }

                // XP Progress bar
                GeometryReader { geometry in
                    ZStack(alignment: .leading) {
                        Capsule()
                            .fill(Color(.systemGray5))
                            .frame(height: 8)

                        Capsule()
                            .fill(AppColors.levelGradient(for: level))
                            .frame(width: geometry.size.width * xpProgress, height: 8)
                    }
                }
                .frame(height: 8)

                Text("Next level: \(xpForNext - currentXP) XP needed")
                    .font(AppFonts.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding(16)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct XPGainBadge: View {
    let amount: Int

    @State private var isVisible = false
    @State private var offset: CGFloat = 0

    var body: some View {
        Text("+\(amount) XP")
            .font(AppFonts.headline)
            .foregroundColor(.yellow)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.yellow.opacity(0.2))
            .clipShape(Capsule())
            .opacity(isVisible ? 1 : 0)
            .offset(y: offset)
            .onAppear {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                    isVisible = true
                }
                withAnimation(.easeOut(duration: 2).delay(0.5)) {
                    offset = -30
                }
                withAnimation(.easeOut(duration: 0.5).delay(2)) {
                    isVisible = false
                }
            }
    }
}

struct LevelUpView: View {
    let newLevel: Int
    let title: String
    let onDismiss: () -> Void

    @State private var showContent = false

    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()
                .onTapGesture {
                    onDismiss()
                }

            VStack(spacing: 24) {
                Text("LEVEL UP!")
                    .font(.system(size: 36, weight: .black, design: .rounded))
                    .foregroundStyle(AppColors.gradient)

                LevelBadge(level: newLevel, title: title, size: 120)
                    .scaleEffect(showContent ? 1 : 0.5)

                Text(title)
                    .font(AppFonts.title)
                    .foregroundColor(.white)

                Text("You've reached level \(newLevel)!")
                    .font(AppFonts.body)
                    .foregroundColor(.gray)

                Button(action: onDismiss) {
                    Text("Continue")
                        .font(AppFonts.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 14)
                        .background(AppColors.gradient)
                        .clipShape(Capsule())
                }
                .padding(.top, 16)
            }
            .padding(32)
            .background(Color(.systemGray6))
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .padding(24)
            .scaleEffect(showContent ? 1 : 0.8)
            .opacity(showContent ? 1 : 0)
        }
        .onAppear {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                showContent = true
            }
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(.success)
        }
    }
}

#Preview {
    VStack(spacing: 24) {
        HStack(spacing: 16) {
            LevelBadge(level: 5, title: "Beginner", size: 60)
            LevelBadge(level: 20, title: "Warrior", size: 60)
            LevelBadge(level: 40, title: "Champion", size: 60)
            LevelBadge(level: 65, title: "Legend", size: 60)
            LevelBadge(level: 85, title: "Immortal", size: 60)
        }

        LevelCard(
            level: 23,
            title: "Warrior",
            xpProgress: 0.65,
            currentXP: 4250,
            xpForNext: 6500
        )

        XPGainBadge(amount: 50)
    }
    .padding()
    .preferredColorScheme(.dark)
}
