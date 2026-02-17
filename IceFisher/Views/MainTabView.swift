import SwiftUI

struct MainTabView: View {
    @State private var settingsViewModel = SettingsViewModel()
    
    var body: some View {
        TabView {
            MainView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Main")
                }
            
            TipsView()
                .tabItem {
                    Image(systemName: "lightbulb.fill")
                    Text("Tips")
                }
            
            CatchView()
                .tabItem {
                    Image(systemName: "fish.fill")
                    Text("Catches")
                }
            
            SettingsView(viewModel: settingsViewModel)
                .tabItem {
                    Image(systemName: "gearshape.fill")
                    Text("Settings")
                }
        }
        .environment(settingsViewModel)
        .preferredColorScheme(settingsViewModel.selectedTheme.colorScheme)
    }
}
