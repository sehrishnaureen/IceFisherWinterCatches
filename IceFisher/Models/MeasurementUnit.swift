import Foundation

enum MeasurementUnit: String, CaseIterable, Identifiable {
    case metric = "Metric"
    case imperial = "Imperial"
    
    var id: String { rawValue }
    
    var weightLabel: String {
        switch self {
        case .metric: return "kg"
        case .imperial: return "lb"
        }
    }
    
    var lengthLabel: String {
        switch self {
        case .metric: return "cm"
        case .imperial: return "in"
        }
    }
    
    var icon: String {
        switch self {
        case .metric: return "scalemass"
        case .imperial: return "scalemass.fill"
        }
    }
}

enum UnitConverter {
    private static let kgToLb = 2.20462
    private static let cmToIn = 0.393701
    
    static func weightToDisplay(_ kg: Double, unit: MeasurementUnit) -> Double {
        switch unit {
        case .metric: return kg
        case .imperial: return kg * kgToLb
        }
    }
    
    static func weightToStorage(_ value: Double, unit: MeasurementUnit) -> Double {
        switch unit {
        case .metric: return value
        case .imperial: return value / kgToLb
        }
    }
    
    static func lengthToDisplay(_ cm: Double, unit: MeasurementUnit) -> Double {
        switch unit {
        case .metric: return cm
        case .imperial: return cm * cmToIn
        }
    }
    
    static func lengthToStorage(_ value: Double, unit: MeasurementUnit) -> Double {
        switch unit {
        case .metric: return value
        case .imperial: return value / cmToIn
        }
    }
    
    static func formattedWeight(_ kg: Double, unit: MeasurementUnit) -> String {
        let value = weightToDisplay(kg, unit: unit)
        return "\(String(format: "%.1f", value)) \(unit.weightLabel)"
    }
    
    static func formattedLength(_ cm: Double, unit: MeasurementUnit) -> String {
        let value = lengthToDisplay(cm, unit: unit)
        return "\(String(format: "%.1f", value)) \(unit.lengthLabel)"
    }
}
