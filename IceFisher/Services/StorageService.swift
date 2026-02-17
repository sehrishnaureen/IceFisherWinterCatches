import Foundation

final class StorageService {
    static let shared = StorageService()
    
    private let defaults = UserDefaults.standard
    
    private enum Keys {
        static let accessToken = "accessToken"
        static let remoteLink = "remoteLink"
        static let catches = "catches"
        static let theme = "theme"
        static let measurementUnit = "measurementUnit"
        static let reviewShown = "reviewShown"
        static let tokenObtainedInSession = "tokenObtainedInSession"
    }
    
    private init() {}
    
    var accessToken: String? {
        get { defaults.string(forKey: Keys.accessToken) }
        set { defaults.set(newValue, forKey: Keys.accessToken) }
    }
    
    var remoteLink: String? {
        get { defaults.string(forKey: Keys.remoteLink) }
        set { defaults.set(newValue, forKey: Keys.remoteLink) }
    }
    
    var reviewShown: Bool {
        get { defaults.bool(forKey: Keys.reviewShown) }
        set { defaults.set(newValue, forKey: Keys.reviewShown) }
    }
    
    var tokenObtainedInSession: Bool {
        get { defaults.bool(forKey: Keys.tokenObtainedInSession) }
        set { defaults.set(newValue, forKey: Keys.tokenObtainedInSession) }
    }
    
    var savedUnit: MeasurementUnit {
        get {
            guard let raw = defaults.string(forKey: Keys.measurementUnit),
                  let unit = MeasurementUnit(rawValue: raw) else {
                return .metric
            }
            return unit
        }
        set { defaults.set(newValue.rawValue, forKey: Keys.measurementUnit) }
    }
    
    var savedTheme: AppTheme {
        get {
            guard let raw = defaults.string(forKey: Keys.theme),
                  let theme = AppTheme(rawValue: raw) else {
                return .system
            }
            return theme
        }
        set { defaults.set(newValue.rawValue, forKey: Keys.theme) }
    }
    
    func saveCatches(_ catches: [CatchRecord]) {
        if let data = try? JSONEncoder().encode(catches) {
            defaults.set(data, forKey: Keys.catches)
        }
    }
    
    func loadCatches() -> [CatchRecord] {
        guard let data = defaults.data(forKey: Keys.catches),
              let catches = try? JSONDecoder().decode([CatchRecord].self, from: data) else {
            return []
        }
        return catches
    }
    
    func clearSessionFlag() {
        defaults.set(false, forKey: Keys.tokenObtainedInSession)
    }
}
