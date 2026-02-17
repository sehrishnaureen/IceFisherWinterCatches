import Foundation
import SwiftUI

@Observable
final class SettingsViewModel {
    var selectedTheme: AppTheme {
        didSet {
            storage.savedTheme = selectedTheme
        }
    }
    
    var selectedUnit: MeasurementUnit {
        didSet {
            storage.savedUnit = selectedUnit
        }
    }
    
    private let storage = StorageService.shared
    
    init() {
        selectedTheme = StorageService.shared.savedTheme
        selectedUnit = StorageService.shared.savedUnit
    }
}
