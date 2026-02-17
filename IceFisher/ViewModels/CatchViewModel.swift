import Foundation
import SwiftUI

@Observable
final class CatchViewModel {
    var catches: [CatchRecord] = []
    var showingAddSheet = false
    
    var newFishType = ""
    var newWeight = ""
    var newLength = ""
    var newLocation = ""
    var newNotes = ""
    var newCatchTime = Date()
    
    private let storage = StorageService.shared
    
    let fishTypes = ["Perch", "Pike", "Walleye", "Trout", "Bass", "Crappie", "Bluegill", "Catfish", "Carp", "Other"]
    
    init() {
        loadCatches()
    }
    
    func loadCatches() {
        catches = storage.loadCatches()
    }
    
    func addCatch(unit: MeasurementUnit) {
        guard !newFishType.isEmpty else { return }
        
        let inputWeight = Double(newWeight) ?? 0
        let inputLength = Double(newLength) ?? 0
        
        let record = CatchRecord(
            fishType: newFishType,
            weight: UnitConverter.weightToStorage(inputWeight, unit: unit),
            length: UnitConverter.lengthToStorage(inputLength, unit: unit),
            catchTime: newCatchTime,
            location: newLocation,
            notes: newNotes
        )
        
        catches.insert(record, at: 0)
        storage.saveCatches(catches)
        resetForm()
    }
    
    func deleteCatch(at offsets: IndexSet) {
        catches.remove(atOffsets: offsets)
        storage.saveCatches(catches)
    }
    
    private func resetForm() {
        newFishType = ""
        newWeight = ""
        newLength = ""
        newLocation = ""
        newNotes = ""
        newCatchTime = Date()
        showingAddSheet = false
    }
    
    func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
