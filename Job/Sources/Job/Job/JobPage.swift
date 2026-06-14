import SwiftData
import SwiftUI
import Model

struct JobPage: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Bindable var job: Job

    @State private var isPresentingEditForm = false

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 10) {
                    HStack(alignment: .firstTextBaseline) {
                        Text(job.title)
                            .font(.title2.bold())
                        Spacer()
                        StatusBadgeView(status: job.status)
                    }

                    Text(job.customer?.name ?? "No Customer")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 6)
            }

            Section("Schedule") {
                Label {
                    Text(job.date, format: .dateTime.weekday(.wide).month(.wide).day().hour().minute())
                } icon: {
                    Image(systemName: "calendar")
                }

                if !job.address.isEmpty {
                    Label(job.address, systemImage: "mappin.and.ellipse")
                }
            }

            Section("Payment") {
                LabeledContent("Amount", value: job.price.formatted(.currency(code: "USD")))
            }

            Section("Status") {
                Picker("Status", selection: $job.status) {
                    ForEach(JobStatus.allCases) { status in
                        HStack {
                            Circle()
                                .fill(status.tint)
                                .frame(width: 8, height: 8)
                            Text(status.title)
                        }
                        .tag(status)
                    }
                }
                .pickerStyle(.inline)
            }

            if let notes = job.notes, !notes.isEmpty {
                Section("Notes") {
                    Text(notes)
                }
            }

            Section {
                Button(role: .destructive) {
                    modelContext.delete(job)
                    dismiss()
                } label: {
                    Label("Delete Job", systemImage: "trash")
                }
            }
        }
        .navigationTitle("Job Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Edit") {
                    isPresentingEditForm = true
                }
            }
        }
        .sheet(isPresented: $isPresentingEditForm) {
            JobFormPage(mode: .edit(job))
        }
    }
}

#Preview {
    NavigationStack {
        JobPage(job: .mock)
    }
    .modelContainer(.mock)
}
