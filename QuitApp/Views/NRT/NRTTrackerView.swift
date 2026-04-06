import SwiftUI

struct NRTTrackerView: View {
    @EnvironmentObject var appState: AppState
    @State private var showAddProduct = false
    @State private var showLogUsage = false
    @State private var selectedProduct: NRTProduct?

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Stats overview
                nrtStatsCard
                    .padding(.horizontal)

                // Net savings
                netSavingsCard
                    .padding(.horizontal)

                // Products list
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Text("Your NRT Products")
                            .font(AppFonts.headline)
                            .foregroundColor(.white)

                        Spacer()

                        Button(action: { showAddProduct = true }) {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 24))
                                .foregroundStyle(AppColors.gradient)
                        }
                    }
                    .padding(.horizontal)

                    if appState.nrtProducts.isEmpty {
                        emptyProductsView
                            .padding(.horizontal)
                    } else {
                        ForEach(appState.nrtProducts, id: \.id) { product in
                            NRTProductCard(product: product) {
                                selectedProduct = product
                                showLogUsage = true
                            }
                            .padding(.horizontal)
                        }
                    }
                }

                Spacer(minLength: 120)
            }
            .padding(.top, 16)
        }
        .background(Color.black)
        .navigationTitle("NRT Tracker")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showAddProduct) {
            NRTProductSetupView()
        }
        .sheet(isPresented: $showLogUsage) {
            if let product = selectedProduct {
                NRTLogEntryView(product: product)
            }
        }
    }

    private var nrtStatsCard: some View {
        let (_, totalCost, todayNicotine) = appState.getNRTStats()

        return VStack(spacing: 16) {
            HStack {
                Text("Today's NRT Usage")
                    .font(AppFonts.headline)
                    .foregroundColor(.white)

                Spacer()
            }

            HStack(spacing: 20) {
                VStack {
                    Text(String(format: "%.1f", todayNicotine))
                        .font(AppFonts.title)
                        .foregroundColor(.orange)

                    Text("mg nicotine")
                        .font(AppFonts.caption)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)

                Divider()
                    .frame(height: 40)
                    .background(Color.gray.opacity(0.3))

                VStack {
                    Text(totalCost.currencyFormatted)
                        .font(AppFonts.title)
                        .foregroundColor(.blue)

                    Text("total spent")
                        .font(AppFonts.caption)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(20)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var netSavingsCard: some View {
        let (_, nrtCost, _) = appState.getNRTStats()
        let netSavings = appState.netSavings

        return VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Net Savings")
                        .font(AppFonts.caption)
                        .foregroundColor(.gray)

                    Text("Money saved minus NRT costs")
                        .font(.system(size: 10))
                        .foregroundColor(.gray.opacity(0.7))
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 4) {
                    Text(netSavings.currencyFormatted)
                        .font(AppFonts.title2)
                        .foregroundColor(netSavings >= 0 ? .green : .red)

                    HStack(spacing: 4) {
                        Text(appState.moneySaved.currencyFormatted)
                            .font(AppFonts.caption)
                            .foregroundColor(.green)

                        Text("-")
                            .font(AppFonts.caption)
                            .foregroundColor(.gray)

                        Text(nrtCost.currencyFormatted)
                            .font(AppFonts.caption)
                            .foregroundColor(.blue)
                    }
                }
            }
        }
        .padding(20)
        .background(
            LinearGradient(
                colors: [Color(.systemGray6), Color(.systemGray5)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }

    private var emptyProductsView: some View {
        VStack(spacing: 16) {
            Image(systemName: "pills.fill")
                .font(.system(size: 40))
                .foregroundColor(.gray)

            Text("No NRT Products")
                .font(AppFonts.headline)
                .foregroundColor(.white)

            Text("Add your nicotine replacement therapy products to track usage and costs")
                .font(AppFonts.caption)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)

            Button(action: { showAddProduct = true }) {
                Text("Add Product")
                    .font(AppFonts.headline)
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(AppColors.gradient)
                    .clipShape(Capsule())
            }
            .padding(.top, 8)
        }
        .padding(32)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

struct NRTProductCard: View {
    let product: NRTProduct
    let onLog: () -> Void

    var body: some View {
        HStack(spacing: 16) {
            // Icon
            ZStack {
                Circle()
                    .fill(Color.blue.opacity(0.2))
                    .frame(width: 50, height: 50)

                Image(systemName: product.productType.icon)
                    .font(.system(size: 24))
                    .foregroundColor(.blue)
            }

            // Info
            VStack(alignment: .leading, spacing: 4) {
                Text(product.brand.isEmpty ? product.productType.rawValue : product.brand)
                    .font(AppFonts.headline)
                    .foregroundColor(.white)

                HStack(spacing: 12) {
                    Label("\(String(format: "%.1f", product.nicotineContent)) mg", systemImage: "drop.fill")
                        .font(AppFonts.caption)
                        .foregroundColor(.orange)

                    Label(product.costPerUnit.currencyFormatted + "/\(product.productType.unit)", systemImage: "dollarsign.circle")
                        .font(AppFonts.caption)
                        .foregroundColor(.green)
                }
            }

            Spacer()

            // Log button
            Button(action: onLog) {
                Text("Log")
                    .font(AppFonts.caption)
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.blue)
                    .clipShape(Capsule())
            }
        }
        .padding(16)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    NavigationStack {
        NRTTrackerView()
            .environmentObject(AppState())
            .preferredColorScheme(.dark)
    }
}
