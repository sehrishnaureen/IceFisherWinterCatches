import Foundation

struct FishingTip: Identifiable {
    let id: UUID
    let title: String
    let description: String
    let category: TipCategory
    let icon: String
    
    init(id: UUID = UUID(), title: String, description: String, category: TipCategory, icon: String) {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.icon = icon
    }
}

enum TipCategory: String, CaseIterable {
    case safety = "Safety"
    case equipment = "Equipment"
    case technique = "Technique"
    case weather = "Weather"
    case location = "Location"
}
