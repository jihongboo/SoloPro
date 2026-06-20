//
//  DatePickerPage.swift
//  Widgets
//
//  Created by 纪洪波 on 6/18/26.
//

import SwiftUI

public struct DatePickerPage: View {
    @Environment(\.dismiss) private var dismiss

    @Binding private var selectedDates: Set<DateComponents>
    @State private var draftDates: Set<DateComponents>

    public init(selectedDates: Binding<Set<DateComponents>>) {
        _selectedDates = selectedDates
        _draftDates = State(initialValue: selectedDates.wrappedValue)
    }

    public var body: some View {
        NavigationStack {
            List {
                Section {
                    MultiDatePicker("Dates", selection: $draftDates)
                }

                Section {
                    Button("Clear Selection") {
                        selectedDates = []
                        draftDates = []
                        dismiss()
                    }
                    .disabled(selectedDates.isEmpty && draftDates.isEmpty)
                }
            }
            .navigationTitle("Select Dates")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        selectedDates = draftDates
                        dismiss()
                    }
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var selectedDates: Set<DateComponents> = []
    DatePickerPage(selectedDates: $selectedDates)
}
