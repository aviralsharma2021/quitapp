import SwiftUI

struct NRTLogEntryView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss

    let product: NRTProduct

    @State private var quantity: Int = 1
    @State private var notes: String = ""
    @State private var timestamp: Date = Date()

    var totalNicotine: Double {
        product.nicotineContent * Double(quantity)
    }

    var totalCost: Double {
        product.costPerUnit * Double(quantity)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(product.brand.isEmpty ? product.productType.rawValue : product.brand)
                                .font(AppFonts.headline)

                            Text("\(String(format: "%.1f", product.nicotineContent)) mg per \(product.productType.unit)")
                                .font(AppFonts.caption)
                                .foregroundColor(.gray)
                        }

                        Spacer()

                        Image(systemName: product.productType.icon)
                            .font(.system(size: 32))
                            .foregroundColor(.blue)
                    }
                }

                Section("Usage") {
                    DatePicker("Time", selection: $timestamp, displayedComponents: [.date, .hourAndMinute])

                    Stepper("Quantity: \(quantity)", value: $quantity, in: 1...20)

                    TextField("Notes (optional)", text: $notes, axis: .vertical)
                        .lineLimit(2...4)
                }

                Section("Summary") {
                    HStack {
                        Text("Total Nicotine")
                        Spacer()
                        Text("\(String(format: "%.1f", totalNicotine)) mg")
                            .foregroundColor(.orange)
                    }

                    HStack {
                        Text("Total Cost")
                        Spacer()
                        Text(totalCost.currencyFormatted)
                            .foregroundColor(.blue)
                    }
                }
            }
            .navigationTitle("Log NRT Usage")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        logUsage()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }

    private func logUsage() {
        appState.logNRTUsage(
            product: product,
            quantity: quantity,
            notes: notes.isEmpty ? nil : notes
        )
        dismiss()
    }
}

#Preview {
    let product = NRTProduct(type: .patch, brand: "Nicorette", nicotineContent: 21, costPerUnit: 3.50, unitsPerPack: 7)
    return NRTLogEntryView(product: product)
        .environmentObject(AppState())
        .preferredColorScheme(.dark)
}
