import SwiftUI

struct NRTProductSetupView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.dismiss) private var dismiss

    @State private var selectedType: NRTProductType = .patch
    @State private var brand: String = ""
    @State private var nicotineContent: Double = 21.0
    @State private var costPerUnit: Double = 3.0
    @State private var unitsPerPack: Int = 7

    var body: some View {
        NavigationStack {
            Form {
                Section("Product Type") {
                    Picker("Type", selection: $selectedType) {
                        ForEach(NRTProductType.allCases, id: \.self) { type in
                            HStack {
                                Image(systemName: type.icon)
                                Text(type.rawValue)
                            }
                            .tag(type)
                        }
                    }
                    .onChange(of: selectedType) { _, newValue in
                        nicotineContent = newValue.defaultNicotineMg
                    }
                }

                Section("Details") {
                    TextField("Brand (optional)", text: $brand)

                    HStack {
                        Text("Nicotine Content (mg)")
                        Spacer()
                        TextField("mg", value: $nicotineContent, format: .number)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                    }
                }

                Section("Cost") {
                    HStack {
                        Text("Cost per \(selectedType.unit)")
                        Spacer()
                        TextField("0.00", value: $costPerUnit, format: .currency(code: "USD"))
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 100)
                    }

                    HStack {
                        Text("\(selectedType.unit.capitalized)s per pack")
                        Spacer()
                        Stepper("\(unitsPerPack)", value: $unitsPerPack, in: 1...100)
                    }

                    HStack {
                        Text("Total pack cost")
                        Spacer()
                        Text((costPerUnit * Double(unitsPerPack)).currencyFormatted)
                            .foregroundColor(.gray)
                    }
                }
            }
            .navigationTitle("Add NRT Product")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        addProduct()
                    }
                    .fontWeight(.semibold)
                }
            }
        }
    }

    private func addProduct() {
        let product = NRTProduct(
            type: selectedType,
            brand: brand,
            nicotineContent: nicotineContent,
            costPerUnit: costPerUnit,
            unitsPerPack: unitsPerPack
        )
        appState.addNRTProduct(product)
        dismiss()
    }
}

#Preview {
    NRTProductSetupView()
        .environmentObject(AppState())
        .preferredColorScheme(.dark)
}
