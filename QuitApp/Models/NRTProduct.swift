import Foundation
import SwiftData

enum NRTProductType: String, Codable, CaseIterable {
    case patch = "Patch"
    case gum = "Gum"
    case lozenge = "Lozenge"
    case spray = "Nasal Spray"
    case inhaler = "Inhaler"
    case pouch = "Nicotine Pouch"

    var icon: String {
        switch self {
        case .patch: return "bandage.fill"
        case .gum: return "mouth.fill"
        case .lozenge: return "pills.fill"
        case .spray: return "humidity.fill"
        case .inhaler: return "lungs.fill"
        case .pouch: return "shippingbox.fill"
        }
    }

    var defaultNicotineMg: Double {
        switch self {
        case .patch: return 21.0
        case .gum: return 4.0
        case .lozenge: return 4.0
        case .spray: return 1.0
        case .inhaler: return 4.0
        case .pouch: return 6.0
        }
    }

    var unit: String {
        switch self {
        case .patch: return "patch"
        case .gum: return "piece"
        case .lozenge: return "lozenge"
        case .spray: return "spray"
        case .inhaler: return "cartridge"
        case .pouch: return "pouch"
        }
    }
}

@Model
final class NRTProduct {
    var id: UUID
    var type: String // Store as String for SwiftData
    var brand: String
    var nicotineContent: Double // mg per unit
    var costPerUnit: Double
    var unitsPerPack: Int
    var isActive: Bool

    var productType: NRTProductType {
        get { NRTProductType(rawValue: type) ?? .gum }
        set { type = newValue.rawValue }
    }

    var costPerPack: Double {
        costPerUnit * Double(unitsPerPack)
    }

    init(
        type: NRTProductType = .gum,
        brand: String = "",
        nicotineContent: Double = 4.0,
        costPerUnit: Double = 0.50,
        unitsPerPack: Int = 20
    ) {
        self.id = UUID()
        self.type = type.rawValue
        self.brand = brand
        self.nicotineContent = nicotineContent
        self.costPerUnit = costPerUnit
        self.unitsPerPack = unitsPerPack
        self.isActive = true
    }
}

@Model
final class NRTUsageLog {
    var id: UUID
    var productId: UUID
    var timestamp: Date
    var quantity: Int
    var nicotineAmount: Double // total mg
    var cost: Double
    var notes: String?

    init(
        productId: UUID,
        quantity: Int = 1,
        nicotineAmount: Double,
        cost: Double,
        notes: String? = nil
    ) {
        self.id = UUID()
        self.productId = productId
        self.timestamp = Date()
        self.quantity = quantity
        self.nicotineAmount = nicotineAmount
        self.cost = cost
        self.notes = notes
    }
}
