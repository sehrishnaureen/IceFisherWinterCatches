import SwiftUI

struct MainView: View {
    @State private var viewModel = MainViewModel()
    @Environment(SettingsViewModel.self) private var settings
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    DatePicker(
                        "Select Date",
                        selection: $viewModel.selectedDate,
                        displayedComponents: .date
                    )
                    .datePickerStyle(.graphical)
                    .padding(.horizontal)
                    .onChange(of: viewModel.selectedDate) {
                        viewModel.loadCatches()
                    }
                    
                    if !viewModel.catchesForSelectedDate.isEmpty {
                        HStack(spacing: 30) {
                            StatCard(
                                title: "Catches",
                                value: "\(viewModel.totalCount)",
                                icon: "fish.fill"
                            )
                            StatCard(
                                title: "Total Weight",
                                value: UnitConverter.formattedWeight(viewModel.totalWeight, unit: settings.selectedUnit),
                                icon: "scalemass"
                            )
                        }
                        .padding()
                    }
                    
                    if viewModel.catchesForSelectedDate.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "calendar.badge.exclamationmark")
                                .font(.system(size: 50))
                                .foregroundColor(.secondary.opacity(0.5))
                            
                            Text("No catches on this day")
                                .font(.headline)
                                .foregroundColor(.secondary)
                        }
                        .padding(.top, 40)
                    } else {
                        LazyVStack(spacing: 0) {
                            ForEach(viewModel.catchesForSelectedDate) { record in
                                DailyCatchRow(record: record, viewModel: viewModel, unit: settings.selectedUnit)
                                    .padding(.horizontal)
                                    .padding(.vertical, 8)
                                
                                if record.id != viewModel.catchesForSelectedDate.last?.id {
                                    Divider()
                                        .padding(.horizontal)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Daily Catches")
            .onAppear {
                viewModel.loadCatches()
            }
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let icon: String
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct DailyCatchRow: View {
    let record: CatchRecord
    let viewModel: MainViewModel
    let unit: MeasurementUnit
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "fish.fill")
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 40, height: 40)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(record.fishType)
                    .font(.headline)
                
                HStack(spacing: 12) {
                    if record.weight > 0 {
                        Text(UnitConverter.formattedWeight(record.weight, unit: unit))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    if record.length > 0 {
                        Text(UnitConverter.formattedLength(record.length, unit: unit))
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            }
            
            Spacer()
            
            Text(viewModel.formattedTime(record.catchTime))
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}
