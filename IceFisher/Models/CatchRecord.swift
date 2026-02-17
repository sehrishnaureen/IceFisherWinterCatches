import Foundation

struct CatchRecord: Identifiable, Codable {
    let id: UUID
    var fishType: String
    var weight: Double
    var length: Double
    var catchTime: Date
    var location: String
    var notes: String
    
    init(id: UUID = UUID(), fishType: String, weight: Double, length: Double, catchTime: Date = Date(), location: String = "", notes: String = "") {
        self.id = id
        self.fishType = fishType
        self.weight = weight
        self.length = length
        self.catchTime = catchTime
        self.location = location
        self.notes = notes
    }
}
