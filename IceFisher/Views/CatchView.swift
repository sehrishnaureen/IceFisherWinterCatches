import SwiftUI

struct CatchView: View {
    @State private var viewModel = CatchViewModel()
    @Environment(SettingsViewModel.self) private var settings
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.catches.isEmpty {
                    EmptyCatchView()
                } else {
                    List {
                        ForEach(viewModel.catches) { record in
                            CatchRow(record: record, viewModel: viewModel, unit: settings.selectedUnit)
                        }
                        .onDelete(perform: viewModel.deleteCatch)
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("My Catches")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { viewModel.showingAddSheet = true }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $viewModel.showingAddSheet) {
                AddCatchSheet(viewModel: viewModel, unit: settings.selectedUnit)
            }
        }
    }
}

struct EmptyCatchView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "fish")
                .font(.system(size: 60))
                .foregroundColor(.blue.opacity(0.5))
            
            Text("No Catches Yet")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Tap the + button to record your first catch")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
        }
    }
}

struct CatchRow: View {
    let record: CatchRecord
    let viewModel: CatchViewModel
    let unit: MeasurementUnit
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "fish.fill")
                    .foregroundColor(.blue)
                    .font(.title2)
                
                Text(record.fishType)
                    .font(.headline)
                
                Spacer()
                
                Text(viewModel.formattedTime(record.catchTime))
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            HStack(spacing: 16) {
                if record.weight > 0 {
                    Label(UnitConverter.formattedWeight(record.weight, unit: unit), systemImage: "scalemass")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                if record.length > 0 {
                    Label(UnitConverter.formattedLength(record.length, unit: unit), systemImage: "ruler")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                if !record.location.isEmpty {
                    Label(record.location, systemImage: "mappin")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
            
            if !record.notes.isEmpty {
                Text(record.notes)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .padding(.vertical, 4)
    }
}

struct AddCatchSheet: View {
    @Bindable var viewModel: CatchViewModel
    @Environment(\.dismiss) private var dismiss
    let unit: MeasurementUnit
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Fish Details") {
                    Picker("Fish Type", selection: $viewModel.newFishType) {
                        Text("Select Type").tag("")
                        ForEach(viewModel.fishTypes, id: \.self) { type in
                            Text(type).tag(type)
                        }
                    }
                    
                    HStack {
                        Text("Weight (\(unit.weightLabel))")
                        Spacer()
                        TextField("0.0", text: $viewModel.newWeight)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                    }
                    
                    HStack {
                        Text("Length (\(unit.lengthLabel))")
                        Spacer()
                        TextField("0.0", text: $viewModel.newLength)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 80)
                    }
                }
                
                Section("Time & Location") {
                    DatePicker("Catch Time", selection: $viewModel.newCatchTime)
                    
                    TextField("Location", text: $viewModel.newLocation)
                }
                
                Section("Notes") {
                    TextField("Add notes about this catch...", text: $viewModel.newNotes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("Add Catch")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        viewModel.addCatch(unit: unit)
                    }
                    .disabled(viewModel.newFishType.isEmpty)
                }
            }
        }
    }
}
