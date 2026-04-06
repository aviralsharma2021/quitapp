import SwiftUI

struct ProgressRing: View {
    let progress: Double // 0.0 to 1.0
    let lineWidth: CGFloat
    let size: CGFloat
    var gradient: LinearGradient = AppColors.gradient
    var backgroundColor: Color = Color.gray.opacity(0.2)

    @State private var animatedProgress: Double = 0

    var body: some View {
        ZStack {
            // Background ring
            Circle()
                .stroke(backgroundColor, lineWidth: lineWidth)
                .frame(width: size, height: size)

            // Progress ring
            Circle()
                .trim(from: 0, to: animatedProgress)
                .stroke(
                    gradient,
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round
                    )
                )
                .frame(width: size, height: size)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 1), value: animatedProgress)

            // Glow effect
            Circle()
                .trim(from: max(0, animatedProgress - 0.05), to: animatedProgress)
                .stroke(
                    gradient,
                    style: StrokeStyle(
                        lineWidth: lineWidth + 4,
                        lineCap: .round
                    )
                )
                .frame(width: size, height: size)
                .rotationEffect(.degrees(-90))
                .blur(radius: 8)
                .opacity(0.6)
                .animation(.easeInOut(duration: 1), value: animatedProgress)
        }
        .onAppear {
            animatedProgress = progress
        }
        .onChange(of: progress) { _, newValue in
            withAnimation(.easeInOut(duration: 0.5)) {
                animatedProgress = newValue
            }
        }
    }
}

struct LevelProgressRing: View {
    let level: Int
    let xpProgress: Double
    let size: CGFloat

    var body: some View {
        ZStack {
            ProgressRing(
                progress: xpProgress,
                lineWidth: 12,
                size: size,
                gradient: AppColors.levelGradient(for: level)
            )

            VStack(spacing: 4) {
                Text("LVL")
                    .font(AppFonts.caption)
                    .foregroundColor(.gray)

                Text("\(level)")
                    .font(.system(size: size * 0.25, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
            }
        }
    }
}

struct MultiRingProgress: View {
    let rings: [(progress: Double, color: Color)]
    let size: CGFloat
    let lineWidth: CGFloat

    var body: some View {
        ZStack {
            ForEach(rings.indices, id: \.self) { index in
                let ring = rings[index]
                let ringSize = size - (CGFloat(index) * (lineWidth + 8) * 2)

                Circle()
                    .stroke(ring.color.opacity(0.2), lineWidth: lineWidth)
                    .frame(width: ringSize, height: ringSize)

                Circle()
                    .trim(from: 0, to: ring.progress)
                    .stroke(
                        ring.color,
                        style: StrokeStyle(lineWidth: lineWidth, lineCap: .round)
                    )
                    .frame(width: ringSize, height: ringSize)
                    .rotationEffect(.degrees(-90))
            }
        }
    }
}

struct CountdownRing: View {
    let totalSeconds: Double
    @Binding var elapsedSeconds: Double
    let size: CGFloat
    var lineWidth: CGFloat = 8

    var progress: Double {
        min(elapsedSeconds / totalSeconds, 1.0)
    }

    var remainingTime: String {
        let remaining = max(0, totalSeconds - elapsedSeconds)
        let minutes = Int(remaining) / 60
        let seconds = Int(remaining) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }

    var body: some View {
        ZStack {
            ProgressRing(
                progress: progress,
                lineWidth: lineWidth,
                size: size,
                gradient: LinearGradient(
                    colors: [.green, .mint],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )

            VStack(spacing: 4) {
                Text(remainingTime)
                    .font(AppFonts.timerSmall)
                    .foregroundColor(.white)
                    .monospacedDigit()

                Text("remaining")
                    .font(AppFonts.caption)
                    .foregroundColor(.gray)
            }
        }
    }
}

#Preview {
    VStack(spacing: 32) {
        ProgressRing(progress: 0.7, lineWidth: 12, size: 150)

        LevelProgressRing(level: 23, xpProgress: 0.65, size: 120)

        MultiRingProgress(
            rings: [
                (0.8, .orange),
                (0.6, .green),
                (0.9, .blue)
            ],
            size: 150,
            lineWidth: 10
        )
    }
    .padding()
    .preferredColorScheme(.dark)
}
