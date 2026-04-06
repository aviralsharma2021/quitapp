import SwiftUI

struct CravingManagerView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss

    @State private var currentStep: CravingStep = .intensity
    @State private var intensity: Int = 5
    @State private var selectedTrigger: CravingTrigger = .stress
    @State private var selectedCoping: CopingTechnique?
    @State private var showTimer = false
    @State private var timerSeconds: Double = 0
    @State private var cravingStartTime = Date()
    @State private var notes: String = ""

    enum CravingStep {
        case intensity
        case trigger
        case coping
        case timer
        case victory
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack(spacing: 0) {
                    // Progress dots
                    HStack(spacing: 8) {
                        ForEach(0..<4) { index in
                            Circle()
                                .fill(stepIndex >= index ? Color.orange : Color(.systemGray5))
                                .frame(width: 8, height: 8)
                        }
                    }
                    .padding(.top, 16)

                    // Content
                    TabView(selection: $currentStep) {
                        intensityStep
                            .tag(CravingStep.intensity)

                        triggerStep
                            .tag(CravingStep.trigger)

                        copingStep
                            .tag(CravingStep.coping)

                        timerStep
                            .tag(CravingStep.timer)

                        victoryStep
                            .tag(CravingStep.victory)
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .animation(.easeInOut, value: currentStep)
                }
            }
            .navigationTitle("Craving Support")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundColor(.gray)
                }
            }
        }
        .onAppear {
            cravingStartTime = Date()
        }
    }

    private var stepIndex: Int {
        switch currentStep {
        case .intensity: return 0
        case .trigger: return 1
        case .coping: return 2
        case .timer: return 3
        case .victory: return 4
        }
    }

    // MARK: - Intensity Step

    private var intensityStep: some View {
        VStack(spacing: 32) {
            Spacer()

            VStack(spacing: 16) {
                Image(systemName: "flame.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(intensityGradient)

                Text("How strong is your craving?")
                    .font(AppFonts.title2)
                    .foregroundColor(.white)
            }

            // Intensity slider
            VStack(spacing: 24) {
                Text("\(intensity)")
                    .font(.system(size: 72, weight: .bold, design: .rounded))
                    .foregroundStyle(intensityGradient)

                Slider(value: Binding(
                    get: { Double(intensity) },
                    set: { intensity = Int($0) }
                ), in: 1...10, step: 1)
                .tint(.orange)
                .padding(.horizontal, 32)

                HStack {
                    Text("Mild")
                        .font(AppFonts.caption)
                        .foregroundColor(.gray)

                    Spacer()

                    Text("Intense")
                        .font(AppFonts.caption)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 32)
            }

            Spacer()

            Button(action: {
                withAnimation {
                    currentStep = .trigger
                }
                haptic(.medium)
            }) {
                Text("Next")
                    .font(AppFonts.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(AppColors.gradient)
                    .clipShape(Capsule())
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
    }

    private var intensityGradient: LinearGradient {
        let colors: [Color] = intensity <= 3 ? [.green, .mint] :
                              intensity <= 6 ? [.yellow, .orange] :
                              [.orange, .red]
        return LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
    }

    // MARK: - Trigger Step

    private var triggerStep: some View {
        VStack(spacing: 24) {
            VStack(spacing: 16) {
                Image(systemName: "questionmark.circle.fill")
                    .font(.system(size: 50))
                    .foregroundStyle(AppColors.gradient)

                Text("What triggered this craving?")
                    .font(AppFonts.title2)
                    .foregroundColor(.white)

                Text("This helps identify patterns")
                    .font(AppFonts.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.top, 32)

            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(CravingTrigger.allCases, id: \.self) { trigger in
                        TriggerButton(
                            trigger: trigger,
                            isSelected: selectedTrigger == trigger
                        ) {
                            selectedTrigger = trigger
                            haptic(.light)
                        }
                    }
                }
                .padding(.horizontal, 24)
            }

            Button(action: {
                withAnimation {
                    currentStep = .coping
                }
                haptic(.medium)
            }) {
                Text("Next")
                    .font(AppFonts.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(AppColors.gradient)
                    .clipShape(Capsule())
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
    }

    // MARK: - Coping Step

    private var copingStep: some View {
        VStack(spacing: 24) {
            VStack(spacing: 16) {
                Image(systemName: "sparkles")
                    .font(.system(size: 50))
                    .foregroundStyle(AppColors.gradient)

                Text("Try a coping technique")
                    .font(AppFonts.title2)
                    .foregroundColor(.white)

                Text("Choose one that works for you")
                    .font(AppFonts.subheadline)
                    .foregroundColor(.gray)
            }
            .padding(.top, 32)

            ScrollView {
                VStack(spacing: 12) {
                    ForEach(CopingTechnique.allCases, id: \.self) { technique in
                        CopingButton(
                            technique: technique,
                            isSelected: selectedCoping == technique
                        ) {
                            selectedCoping = technique
                            haptic(.light)
                        }
                    }
                }
                .padding(.horizontal, 24)
            }

            Button(action: {
                withAnimation {
                    currentStep = .timer
                }
                haptic(.medium)
            }) {
                Text("Start Timer")
                    .font(AppFonts.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(AppColors.gradient)
                    .clipShape(Capsule())
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
    }

    // MARK: - Timer Step

    private var timerStep: some View {
        CravingTimerView(
            selectedCoping: selectedCoping,
            onComplete: {
                withAnimation {
                    currentStep = .victory
                }
                // Log the craving
                let duration = Date().timeIntervalSince(cravingStartTime)
                appState.logCraving(
                    intensity: intensity,
                    trigger: selectedTrigger,
                    copingUsed: selectedCoping,
                    resisted: true,
                    duration: duration,
                    notes: notes.isEmpty ? nil : notes
                )
                haptic(.success)
            }
        )
    }

    // MARK: - Victory Step

    private var victoryStep: some View {
        VStack(spacing: 32) {
            Spacer()

            VStack(spacing: 24) {
                ZStack {
                    Circle()
                        .fill(Color.green)
                        .frame(width: 120, height: 120)
                        .shadow(color: .green.opacity(0.5), radius: 30)

                    Image(systemName: "checkmark")
                        .font(.system(size: 50, weight: .bold))
                        .foregroundColor(.white)
                }

                Text("You Did It!")
                    .font(AppFonts.largeTitle)
                    .foregroundColor(.white)

                Text("You resisted the craving!\nYou're getting stronger every time.")
                    .font(AppFonts.body)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }

            // XP reward
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)

                Text("+\(20 + (intensity * 5)) XP earned")
                    .font(AppFonts.headline)
                    .foregroundColor(.yellow)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .background(Color.yellow.opacity(0.15))
            .clipShape(Capsule())

            Spacer()

            Button(action: { dismiss() }) {
                Text("Done")
                    .font(AppFonts.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.green)
                    .clipShape(Capsule())
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
    }

    private func haptic(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }

    private func haptic(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
}

// MARK: - Trigger Button

struct TriggerButton: View {
    let trigger: CravingTrigger
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: trigger.icon)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? .white : .gray)

                Text(trigger.rawValue)
                    .font(AppFonts.caption)
                    .foregroundColor(isSelected ? .white : .gray)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(isSelected ? AnyShapeStyle(AppColors.gradient) : AnyShapeStyle(Color(.systemGray6)))
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

// MARK: - Coping Button

struct CopingButton: View {
    let technique: CopingTechnique
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: technique.icon)
                    .font(.system(size: 24))
                    .foregroundColor(isSelected ? .white : .orange)
                    .frame(width: 44, height: 44)
                    .background(isSelected ? Color.white.opacity(0.2) : Color.orange.opacity(0.15))
                    .clipShape(RoundedRectangle(cornerRadius: 12))

                VStack(alignment: .leading, spacing: 4) {
                    Text(technique.rawValue)
                        .font(AppFonts.headline)
                        .foregroundColor(isSelected ? .white : .white)

                    Text(technique.description)
                        .font(AppFonts.caption)
                        .foregroundColor(isSelected ? .white.opacity(0.8) : .gray)
                        .lineLimit(2)
                }

                Spacer()

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.white)
                }
            }
            .padding(12)
            .background(isSelected ? AnyShapeStyle(AppColors.gradient) : AnyShapeStyle(Color(.systemGray6)))
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}

// MARK: - Craving Timer View

struct CravingTimerView: View {
    let selectedCoping: CopingTechnique?
    let onComplete: () -> Void

    @State private var elapsedSeconds: Double = 0
    @State private var isActive = true

    private let totalSeconds: Double = 240 // 4 minutes

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            VStack(spacing: 16) {
                Text("Cravings typically pass in 3-5 minutes")
                    .font(AppFonts.subheadline)
                    .foregroundColor(.gray)

                Text("Stay strong!")
                    .font(AppFonts.title)
                    .foregroundColor(.white)
            }

            // Timer ring
            CountdownRing(
                totalSeconds: totalSeconds,
                elapsedSeconds: $elapsedSeconds,
                size: 200,
                lineWidth: 12
            )

            // Coping technique reminder
            if let coping = selectedCoping {
                VStack(spacing: 12) {
                    Image(systemName: coping.icon)
                        .font(.system(size: 32))
                        .foregroundStyle(AppColors.gradient)

                    Text(coping.rawValue)
                        .font(AppFonts.headline)
                        .foregroundColor(.white)

                    Text(coping.description)
                        .font(AppFonts.caption)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 32)
                }
                .padding(20)
                .background(Color(.systemGray6))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .padding(.horizontal, 24)
            }

            Spacer()

            Button(action: onComplete) {
                Text("I Made It!")
                    .font(AppFonts.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.green)
                    .clipShape(Capsule())
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 24)
        }
        .onReceive(timer) { _ in
            if isActive && elapsedSeconds < totalSeconds {
                elapsedSeconds += 1
            }
        }
    }
}

#Preview {
    CravingManagerView()
        .environmentObject(AppState())
        .preferredColorScheme(.dark)
}
