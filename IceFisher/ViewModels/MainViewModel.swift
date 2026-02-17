import Foundation
import SwiftUI

@Observable
final class MainViewModel {
    var selectedDate: Date = Date()
    var allCatches: [CatchRecord] = []
    
    private let storage = StorageService.shared
    
    var catchesForSelectedDate: [CatchRecord] {
        let calendar = Calendar.current
        return allCatches.filter { record in
            calendar.isDate(record.catchTime, inSameDayAs: selectedDate)
        }
    }
    
    var totalWeight: Double {
        catchesForSelectedDate.reduce(0) { $0 + $1.weight }
    }
    
    var totalCount: Int {
        catchesForSelectedDate.count
    }
    
    init() {
        loadCatches()
    }
    
    func loadCatches() {
        allCatches = storage.loadCatches()
    }
    
    func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: date)
    }
}
