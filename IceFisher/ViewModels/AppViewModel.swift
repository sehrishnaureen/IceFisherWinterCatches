import Foundation
import StoreKit
import UIKit
import SwiftUI

enum AppState {
    case loading
    case showRemoteContent(String)
    case showMainApp
}

@Observable
final class AppViewModel {
    var appState: AppState = .loading
    var shouldRequestReview = false
    
    private let storage = StorageService.shared
    private let network = NetworkService.shared
    private var hadTokenOnLaunch = false
    
    init() {
        storage.clearSessionFlag()
    }
    
    func checkInitialState() {
        if let token = storage.accessToken, let link = storage.remoteLink, !token.isEmpty, !link.isEmpty {
            hadTokenOnLaunch = true
            appState = .showRemoteContent(link)
            checkForReviewRequest()
        } else {
            fetchConfiguration()
        }
    }
    
    private func fetchConfiguration() {
        network.fetchConfiguration { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                
                switch result {
                case .success(let response):
                    if response.contains("#") {
                        let components = response.components(separatedBy: "#")
                        if components.count >= 2 {
                            let token = components[0]
                            let link = components[1]
                            self.storage.accessToken = token
                            self.storage.remoteLink = link
                            self.storage.tokenObtainedInSession = true
                            self.appState = .showRemoteContent(link)
                        } else {
                            self.appState = .showMainApp
                        }
                    } else {
                        self.appState = .showMainApp
                    }
                case .failure:
                    self.appState = .showMainApp
                }
            }
        }
    }
    
    private func checkForReviewRequest() {
        guard hadTokenOnLaunch, !storage.reviewShown else { return }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }
            if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                SKStoreReviewController.requestReview(in: scene)
                self.storage.reviewShown = true
            }
        }
    }
}
