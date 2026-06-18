//
//  DatePickerPage.swift
//  Widgets
//
//  Created by 纪洪波 on 6/18/26.
//

import SwiftUI

public struct DatePickerPage: View {
    @Environment(\.dismiss) private var dismiss

    @Binding private var selectedDate: Date?
    @State private var draftDate: Date

    public init(selectedDate: Binding<Date?>) {
        _selectedDate = selectedDate
        _draftDate = State(initialValue: selectedDate.wrappedValue ?? Date())
    }

    public var body: some View {
        NavigationStack {
            List {
                Section {
                    DatePicker(
                        "Date",
                        selection: $draftDate,
                        displayedComponents: .date
                    )
                    .datePickerStyle(.graphical)
                }

                Section {
                    Button("Clear Selection") {
                        selectedDate = nil
                        dismiss()
                    }
                }
            }
            .navigationTitle("Select Date")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        selectedDate = draftDate
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
    @Previewable @State var selectedDate: Date?
    DatePickerPage(selectedDate: $selectedDate)
}
