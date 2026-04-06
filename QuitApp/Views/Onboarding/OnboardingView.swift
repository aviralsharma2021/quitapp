import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var appState: AppState
    @State private var currentStep = 0
    @State private var quitDate = Date()
    @State private var productType: ProductType = .cigarettes
    @State private var dailyConsumption = 20
    @State private var costPerPack = 15.0
    @State private var packSize = 20

    private let totalSteps = 4

    var body: some View {
        ZStack {
            // Animated background
            LinearGradient(
                colors: [
                    Color.black,
                    Color(.systemGray6).opacity(0.3)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            // Floating particles effect
            FloatingParticles()

            VStack(spacing: 0) {
                // Progress indicator
                ProgressIndicator(current: currentStep, total: totalSteps)
                    .padding(.top, 20)
                    .padding(.horizontal, 40)

                // Content
                TabView(selection: $currentStep) {
                    WelcomeStep()
                        .tag(0)

                    QuitDateStep(quitDate: $quitDate)
                        .tag(1)

                    ProductTypeStep(
                        productType: $productType,
                        dailyConsumption: $dailyConsumption
                    )
                        .tag(2)

                    CostStep(
                        costPerPack: $costPerPack,
                        packSize: $packSize,
                        productType: productType
                    )
                        .tag(3)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeInOut, value: currentStep)

                // Navigation buttons
                HStack(spacing: 16) {
                    if currentStep > 0 {
                        Button(action: {
                            withAnimation {
                                currentStep -= 1
                            }
                            hapticFeedback(.light)
                        }) {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("Back")
                            }
                            .font(AppFonts.headline)
                            .foregroundColor(.gray)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 14)
                            .background(Color(.systemGray5))
                            .clipShape(Capsule())
                        }
                    }

                    Spacer()

                    Button(action: {
                        if currentStep < totalSteps - 1 {
                            withAnimation {
                                currentStep += 1
                            }
                            hapticFeedback(.medium)
                        } else {
                            completeOnboarding()
                        }
                    }) {
                        HStack {
                            Text(currentStep == totalSteps - 1 ? "Start Journey" : "Next")
                            Image(systemName: currentStep == totalSteps - 1 ? "flame.fill" : "chevron.right")
                        }
                        .font(AppFonts.headline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 14)
                        .background(AppColors.gradient)
                        .clipShape(Capsule())
                        .shadow(color: .orange.opacity(0.4), radius: 10, y: 5)
                    }
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
            }
        }
    }

    private func completeOnboarding() {
        hapticFeedback(.success)
        appState.createUserProfile(
            quitDate: quitDate,
            productType: productType,
            dailyConsumption: dailyConsumption,
            costPerPack: costPerPack,
            packSize: packSize
        )
    }

    private func hapticFeedback(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }

    private func hapticFeedback(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
}

// MARK: - Progress Indicator

struct ProgressIndicator: View {
    let current: Int
    let total: Int

    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<total, id: \.self) { index in
                Capsule()
                    .fill(index <= current ? AppColors.gradient : LinearGradient(colors: [Color.gray.opacity(0.3)], startPoint: .leading, endPoint: .trailing))
                    .frame(height: 4)
                    .animation(.spring(), value: current)
            }
        }
    }
}

// MARK: - Welcome Step

struct WelcomeStep: View {
    @State private var showContent = false

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            // Icon
            ZStack {
                Circle()
                    .fill(AppColors.gradient)
                    .frame(width: 120, height: 120)
                    .shadow(color: .orange.opacity(0.5), radius: 30, y: 10)

                Image(systemName: "lungs.fill")
                    .font(.system(size: 50))
                    .foregroundColor(.white)
            }
            .scaleEffect(showContent ? 1 : 0.5)
            .opacity(showContent ? 1 : 0)

            VStack(spacing: 16) {
                Text("Welcome to QuitApp")
                    .font(AppFonts.largeTitle)
                    .foregroundColor(.white)

                Text("Your journey to a smoke-free life starts here. We'll help you every step of the way.")
                    .font(AppFonts.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            .offset(y: showContent ? 0 : 20)
            .opacity(showContent ? 1 : 0)

            // Features
            VStack(spacing: 16) {
                FeatureRow(icon: "gamecontroller.fill", title: "Gamified Progress", description: "Earn XP, level up, unlock achievements")
                FeatureRow(icon: "heart.fill", title: "Health Timeline", description: "Watch your body heal in real-time")
                FeatureRow(icon: "dollarsign.circle.fill", title: "Savings Tracker", description: "See how much money you're saving")
            }
            .padding(.horizontal, 24)
            .offset(y: showContent ? 0 : 30)
            .opacity(showContent ? 1 : 0)

            Spacer()
            Spacer()
        }
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.2)) {
                showContent = true
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundStyle(AppColors.gradient)
                .frame(width: 44, height: 44)
                .background(Color(.systemGray5))
                .clipShape(RoundedRectangle(cornerRadius: 12))

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(AppFonts.headline)
                    .foregroundColor(.white)

                Text(description)
                    .font(AppFonts.caption)
                    .foregroundColor(.gray)
            }

            Spacer()
        }
        .padding(12)
        .background(Color(.systemGray6).opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

// MARK: - Quit Date Step

struct QuitDateStep: View {
    @Binding var quitDate: Date
    @State private var showContent = false

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            VStack(spacing: 16) {
                Image(systemName: "calendar.badge.clock")
                    .font(.system(size: 60))
                    .foregroundStyle(AppColors.gradient)

                Text("When did you quit?")
                    .font(AppFonts.title)
                    .foregroundColor(.white)

                Text("Or when do you plan to quit? You can set a future date too.")
                    .font(AppFonts.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            .offset(y: showContent ? 0 : 20)
            .opacity(showContent ? 1 : 0)

            DatePicker(
                "Quit Date",
                selection: $quitDate,
                displayedComponents: [.date, .hourAndMinute]
            )
            .datePickerStyle(.wheel)
            .labelsHidden()
            .colorScheme(.dark)
            .padding(.horizontal, 24)
            .scaleEffect(showContent ? 1 : 0.9)
            .opacity(showContent ? 1 : 0)

            Spacer()
            Spacer()
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1)) {
                showContent = true
            }
        }
    }
}

// MARK: - Product Type Step

struct ProductTypeStep: View {
    @Binding var productType: ProductType
    @Binding var dailyConsumption: Int
    @State private var showContent = false

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            VStack(spacing: 16) {
                Image(systemName: "smoke.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(AppColors.gradient)

                Text("What are you quitting?")
                    .font(AppFonts.title)
                    .foregroundColor(.white)
            }
            .offset(y: showContent ? 0 : 20)
            .opacity(showContent ? 1 : 0)

            // Product type selection
            HStack(spacing: 12) {
                ForEach(ProductType.allCases, id: \.self) { type in
                    ProductTypeButton(
                        type: type,
                        isSelected: productType == type
                    ) {
                        withAnimation(.spring(response: 0.3)) {
                            productType = type
                        }
                        let generator = UIImpactFeedbackGenerator(style: .light)
                        generator.impactOccurred()
                    }
                }
            }
            .padding(.horizontal, 24)
            .scaleEffect(showContent ? 1 : 0.9)
            .opacity(showContent ? 1 : 0)

            // Daily consumption
            VStack(spacing: 16) {
                Text("Daily consumption")
                    .font(AppFonts.headline)
                    .foregroundColor(.white)

                HStack {
                    Button(action: {
                        if dailyConsumption > 1 {
                            dailyConsumption -= 1
                            let generator = UIImpactFeedbackGenerator(style: .light)
                            generator.impactOccurred()
                        }
                    }) {
                        Image(systemName: "minus.circle.fill")
                            .font(.system(size: 36))
                            .foregroundColor(.gray)
                    }

                    Text("\(dailyConsumption)")
                        .font(AppFonts.timer)
                        .foregroundColor(.white)
                        .frame(width: 100)

                    Button(action: {
                        dailyConsumption += 1
                        let generator = UIImpactFeedbackGenerator(style: .light)
                        generator.impactOccurred()
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 36))
                            .foregroundStyle(AppColors.gradient)
                    }
                }

                Text(consumptionLabel)
                    .font(AppFonts.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(24)
            .background(Color(.systemGray6).opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(.horizontal, 24)
            .offset(y: showContent ? 0 : 30)
            .opacity(showContent ? 1 : 0)

            Spacer()
            Spacer()
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1)) {
                showContent = true
            }
        }
    }

    var consumptionLabel: String {
        switch productType {
        case .cigarettes:
            return "cigarettes per day"
        case .vaping:
            return "vape sessions per day"
        case .both:
            return "total sessions per day"
        }
    }
}

struct ProductTypeButton: View {
    let type: ProductType
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: type.icon)
                    .font(.system(size: 28))
                    .foregroundColor(isSelected ? .white : .gray)

                Text(type.rawValue)
                    .font(AppFonts.caption)
                    .foregroundColor(isSelected ? .white : .gray)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(
                isSelected ?
                AnyShapeStyle(AppColors.gradient) :
                AnyShapeStyle(Color(.systemGray5))
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.orange : Color.clear, lineWidth: 2)
            )
        }
    }
}

// MARK: - Cost Step

struct CostStep: View {
    @Binding var costPerPack: Double
    @Binding var packSize: Int
    let productType: ProductType
    @State private var showContent = false

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            VStack(spacing: 16) {
                Image(systemName: "dollarsign.circle.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(AppColors.gradient)

                Text("Cost Information")
                    .font(AppFonts.title)
                    .foregroundColor(.white)

                Text("This helps us calculate your savings")
                    .font(AppFonts.body)
                    .foregroundColor(.gray)
            }
            .offset(y: showContent ? 0 : 20)
            .opacity(showContent ? 1 : 0)

            VStack(spacing: 24) {
                // Cost per pack
                VStack(spacing: 12) {
                    Text("Cost per \(packLabel)")
                        .font(AppFonts.headline)
                        .foregroundColor(.white)

                    HStack {
                        Text("$")
                            .font(AppFonts.title)
                            .foregroundColor(.gray)

                        TextField("0.00", value: $costPerPack, format: .number)
                            .font(AppFonts.timer)
                            .foregroundColor(.white)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.center)
                            .frame(width: 120)
                    }
                }

                Divider()
                    .background(Color.gray.opacity(0.3))

                // Pack size
                VStack(spacing: 12) {
                    Text("\(unitLabel) per \(packLabel)")
                        .font(AppFonts.headline)
                        .foregroundColor(.white)

                    HStack {
                        Button(action: {
                            if packSize > 1 {
                                packSize -= 1
                            }
                        }) {
                            Image(systemName: "minus.circle.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.gray)
                        }

                        Text("\(packSize)")
                            .font(AppFonts.timerSmall)
                            .foregroundColor(.white)
                            .frame(width: 80)

                        Button(action: {
                            packSize += 1
                        }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 30))
                                .foregroundStyle(AppColors.gradient)
                        }
                    }
                }
            }
            .padding(24)
            .background(Color(.systemGray6).opacity(0.5))
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(.horizontal, 24)
            .scaleEffect(showContent ? 1 : 0.9)
            .opacity(showContent ? 1 : 0)

            Spacer()
            Spacer()
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1)) {
                showContent = true
            }
        }
    }

    var packLabel: String {
        switch productType {
        case .cigarettes: return "pack"
        case .vaping: return "pod/cartridge"
        case .both: return "pack/pod"
        }
    }

    var unitLabel: String {
        switch productType {
        case .cigarettes: return "Cigarettes"
        case .vaping: return "Sessions"
        case .both: return "Units"
        }
    }
}

// MARK: - Floating Particles

struct FloatingParticles: View {
    @State private var particles: [Particle] = []

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(particles) { particle in
                    Circle()
                        .fill(particle.color)
                        .frame(width: particle.size, height: particle.size)
                        .position(particle.position)
                        .opacity(particle.opacity)
                        .blur(radius: particle.blur)
                }
            }
            .onAppear {
                createParticles(in: geometry.size)
                animateParticles(in: geometry.size)
            }
        }
        .ignoresSafeArea()
    }

    private func createParticles(in size: CGSize) {
        particles = (0..<15).map { _ in
            Particle(
                position: CGPoint(
                    x: CGFloat.random(in: 0...size.width),
                    y: CGFloat.random(in: 0...size.height)
                ),
                size: CGFloat.random(in: 4...12),
                color: [Color.orange, Color.red, Color.yellow].randomElement()!.opacity(0.3),
                opacity: Double.random(in: 0.1...0.4),
                blur: CGFloat.random(in: 2...8)
            )
        }
    }

    private func animateParticles(in size: CGSize) {
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            for i in particles.indices {
                withAnimation(.linear(duration: 0.05)) {
                    particles[i].position.y -= CGFloat.random(in: 0.5...2)
                    particles[i].position.x += CGFloat.random(in: -0.5...0.5)

                    if particles[i].position.y < -20 {
                        particles[i].position.y = size.height + 20
                        particles[i].position.x = CGFloat.random(in: 0...size.width)
                    }
                }
            }
        }
    }
}

struct Particle: Identifiable {
    let id = UUID()
    var position: CGPoint
    let size: CGFloat
    let color: Color
    let opacity: Double
    let blur: CGFloat
}

#Preview {
    OnboardingView()
        .environmentObject(AppState())
        .preferredColorScheme(.dark)
}
