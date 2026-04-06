import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @State private var showCravingSheet = false

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                DashboardView()
                    .tag(0)

                HealthTimelineView()
                    .tag(1)

                // Placeholder for craving button
                Color.clear
                    .tag(2)

                StatsView()
                    .tag(3)

                AchievementsGalleryView()
                    .tag(4)
            }

            // Custom Tab Bar
            CustomTabBar(
                selectedTab: $selectedTab,
                showCravingSheet: $showCravingSheet
            )
        }
        .ignoresSafeArea(.keyboard)
        .sheet(isPresented: $showCravingSheet) {
            CravingManagerView()
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    @Binding var showCravingSheet: Bool

    var body: some View {
        HStack(spacing: 0) {
            TabBarButton(icon: "house.fill", label: "Home", isSelected: selectedTab == 0) {
                selectedTab = 0
            }

            TabBarButton(icon: "heart.fill", label: "Health", isSelected: selectedTab == 1) {
                selectedTab = 1
            }

            // Center Craving Button
            Button(action: {
                showCravingSheet = true
                let generator = UIImpactFeedbackGenerator(style: .heavy)
                generator.impactOccurred()
            }) {
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color.orange, Color.red],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 64, height: 64)
                        .shadow(color: .orange.opacity(0.5), radius: 10, y: 5)

                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                }
            }
            .offset(y: -20)

            TabBarButton(icon: "chart.bar.fill", label: "Stats", isSelected: selectedTab == 3) {
                selectedTab = 3
            }

            TabBarButton(icon: "trophy.fill", label: "Awards", isSelected: selectedTab == 4) {
                selectedTab = 4
            }
        }
        .padding(.horizontal, 8)
        .padding(.top, 12)
        .padding(.bottom, 20)
        .background(
            RoundedRectangle(cornerRadius: 30)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.2), radius: 20, y: -5)
        )
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }
}

struct TabBarButton: View {
    let icon: String
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: {
            action()
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.impactOccurred()
        }) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20, weight: isSelected ? .bold : .regular))
                    .foregroundColor(isSelected ? .orange : .gray)

                Text(label)
                    .font(.system(size: 10, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? .orange : .gray)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    MainTabView()
        .environmentObject(AppState())
        .preferredColorScheme(.dark)
}
