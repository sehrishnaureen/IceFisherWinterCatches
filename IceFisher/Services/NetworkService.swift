import Foundation
import UIKit

final class NetworkService {
    static let shared = NetworkService()
    
    private init() {}
    
    func fetchConfiguration(completion: @escaping (Result<String, Error>) -> Void) {
        let osVersion = UIDevice.current.systemVersion
        let language = Locale.preferredLanguages.first?.components(separatedBy: "-").first ?? "en"
        let deviceModel = getDeviceModel()
        let country = Locale.current.region?.identifier ?? "US"
        
        let endpoint = "https://gtappinfo.site/ios-icefisher-wintercatches/server.php?p=Bs2675kDjkb5Ga&os=\(osVersion)&lng=\(language)&devicemodel=\(deviceModel)&country=\(country)"
        
        guard let requestAddress = Foundation.URL(string: endpoint) else {
            completion(.failure(NSError(domain: "InvalidEndpoint", code: -1)))
            return
        }
        
        var request = URLRequest(url: requestAddress)
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        request.addValue("no-cache", forHTTPHeaderField: "Cache-Control")
        request.addValue("no-cache", forHTTPHeaderField: "Pragma")
        
        let config = URLSessionConfiguration.default
        config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        config.urlCache = nil
        
        let session = URLSession(configuration: config)
        
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data, let responseString = String(data: data, encoding: .utf8) else {
                completion(.failure(NSError(domain: "InvalidResponse", code: -2)))
                return
            }
            
            completion(.success(responseString))
        }.resume()
    }
    
    private func getDeviceModel() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let model = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return model.lowercased()
    }
}
