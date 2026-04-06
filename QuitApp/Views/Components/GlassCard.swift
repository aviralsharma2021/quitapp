import SwiftUI

struct GlassCard<Content: View>: View {
    let content: Content
    var padding: CGFloat = 16
    var cornerRadius: CGFloat = 20

    init(
        padding: CGFloat = 16,
        cornerRadius: CGFloat = 20,
        @ViewBuilder content: () -> Content
    ) {
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.content = content()
    }

    var body: some View {
        content
            .padding(padding)
            .background(.ultraThinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

struct GradientCard<Content: View>: View {
    let gradient: LinearGradient
    let content: Content
    var padding: CGFloat = 16
    var cornerRadius: CGFloat = 20

    init(
        gradient: LinearGradient = AppColors.gradient,
        padding: CGFloat = 16,
        cornerRadius: CGFloat = 20,
        @ViewBuilder content: () -> Content
    ) {
        self.gradient = gradient
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.content = content()
    }

    var body: some View {
        content
            .padding(padding)
            .background(gradient)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

struct StatCard: View {
    let icon: String
    let title: String
    let value: String
    let subtitle: String?
    var iconColor: Color = .orange

    init(
        icon: String,
        title: String,
        value: String,
        subtitle: String? = nil,
        iconColor: Color = .orange
    ) {
        self.icon = icon
        self.title = title
        self.value = value
        self.subtitle = subtitle
        self.iconColor = iconColor
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(iconColor)

                Spacer()
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(value)
                    .font(AppFonts.title2)
                    .foregroundColor(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)

                Text(title)
                    .font(AppFonts.caption)
                    .foregroundColor(.gray)

                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(AppFonts.caption)
                        .foregroundColor(.gray.opacity(0.7))
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

struct CompactStatCard: View {
    let icon: String
    let value: String
    let label: String
    var iconColor: Color = .orange

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 24, weight: .semibold))
                .foregroundColor(iconColor)
                .frame(width: 44, height: 44)
                .background(iconColor.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 2) {
                Text(value)
                    .font(AppFonts.headline)
                    .foregroundColor(.white)

                Text(label)
                    .font(AppFonts.caption)
                    .foregroundColor(.gray)
            }

            Spacer()
        }
        .padding(12)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 14))
    }
}

#Preview {
    VStack(spacing: 16) {
        GlassCard {
            Text("Glass Card Content")
                .foregroundColor(.white)
        }

        GradientCard {
            Text("Gradient Card Content")
                .foregroundColor(.white)
        }

        StatCard(
            icon: "dollarsign.circle.fill",
            title: "Money Saved",
            value: "$127.50",
            subtitle: "Keep it up!"
        )

        CompactStatCard(
            icon: "flame.fill",
            value: "7 days",
            label: "Current Streak"
        )
    }
    .padding()
    .preferredColorScheme(.dark)
}
