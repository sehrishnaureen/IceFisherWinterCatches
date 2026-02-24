import SwiftUI

struct SettingsView: View {
    @Bindable var viewModel: SettingsViewModel
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Appearance") {
                    ForEach(AppTheme.allCases) { theme in
                        ThemeRow(
                            theme: theme,
                            isSelected: viewModel.selectedTheme == theme,
                            action: { viewModel.selectedTheme = theme }
                        )
                    }
                }
                
                Section("Measurement System") {
                    ForEach(MeasurementUnit.allCases) { unit in
                        UnitRow(
                            unit: unit,
                            isSelected: viewModel.selectedUnit == unit,
                            action: { viewModel.selectedUnit = unit }
                        )
                    }
                }
                
                Section {
                    HStack {
                        Spacer()
                        VStack(spacing: 8) {
                            Image(systemName: "snowflake")
                                .font(.largeTitle)
                                .foregroundColor(.blue)
                            
                            Text("Ice Fisher")
                                .font(.headline)
                            
                            Text("Winter Fish Companion")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    .padding(.vertical, 20)
                }
            }
            .navigationTitle("Settings")
        }
    }
}

struct ThemeRow: View {
    let theme: AppTheme
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: theme.icon)
                    .foregroundColor(.blue)
                    .frame(width: 30)
                
                Text(theme.rawValue)
                    .foregroundColor(.primary)
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.blue)
                }
            }
        }
    }
}

struct UnitRow: View {
    let unit: MeasurementUnit
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: unit.icon)
                    .foregroundColor(.blue)
                    .frame(width: 30)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(unit.rawValue)
                        .foregroundColor(.primary)
                    
                    Text("\(unit.weightLabel) / \(unit.lengthLabel)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .foregroundColor(.blue)
                }
            }
        }
    }
}
