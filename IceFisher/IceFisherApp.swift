import SwiftUI

@main
struct IceFisherApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var appViewModel = AppViewModel()
    
    var body: some Scene {
        WindowGroup {
            RootView(viewModel: appViewModel)
                .onAppear {
                    appViewModel.checkInitialState()
                }
        }
    }
}

struct RootView: View {
    var viewModel: AppViewModel
    
    var body: some View {
        switch viewModel.appState {
        case .loading:
            LoadingView()
        case .showRemoteContent(let address):
            RemoteContentView(address: address)
                .ignoresSafeArea()
                .statusBarHidden(true)
                .persistentSystemOverlays(.hidden)
        case .showMainApp:
            MainTabView()
        }
    }
}

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                .scaleEffect(1.5)
        }
    }
}
