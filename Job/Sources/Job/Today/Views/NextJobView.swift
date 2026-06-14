import SwiftData
import SwiftUI
import Model

struct NextJobView: View {
    let job: Job
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.openURL) private var openURL
    
    private var title: String {
        if job.status == .inProgress { return "Current Job" }
        if job.date < Date() { return "Delayed Job" }
        return "Next Job"
    }
    
    private var address: String {
        job.address.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private var nextStatus: JobStatus {
        switch job.status {
        case .scheduled:
            .inProgress
        case .inProgress:
            .completed
        case .completed, .canceled:
            .scheduled
        }
    }
    
    private var statusButtonTitle: String {
        switch job.status {
        case .scheduled:
            "Start"
        case .inProgress:
            "Complete"
            case .completed, .canceled:
            "Reopen"
        }
    }
    
    private var statusButtonTint: Color {
        nextStatus.tint
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                
                Text(job.title)
                    .font(.headline)
                
                Text("\(Image(systemName: "clock")) \(Text(job.date, format: .dateTime.hour().minute())) \(Text("with \(job.customer?.name ?? "No Customer")"))")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Spacer()
            
            HStack {
                Button(action: advanceStatus) {
                    Text(statusButtonTitle)
                        .font(.caption.bold())
                        .frame(maxHeight: .infinity)
                }
                .tint(statusButtonTint)
                .animation(.smooth, value: job.status)
                
                if !address.isEmpty {
                    Button(action: openInAppleMaps) {
                        Label("Navigate in Maps", systemImage: "map")
                            .labelStyle(.iconOnly)
                            .frame(maxHeight: .infinity)
                    }
 
                }
            }
            .buttonStyle(.borderedProminent)
            .buttonBorderShape(.roundedRectangle)
        }
        .swipeActions(allowsFullSwipe: false) {
            Button(role: .destructive, action: removeJob) {
                Label("Delete Job", systemImage: "trash")
            }
        }
    }
}

#Preview {
    List {
        Section {
            NextJobView(job: .mock)
        }
    }
    .modelContainer(.mock)
}

private extension NextJobView {
    func advanceStatus() {
        job.status = nextStatus
    }
    
    func removeJob() {
        modelContext.delete(job)
    }
    
    func openInAppleMaps() {
        var components = URLComponents(string: "http://maps.apple.com/")
        components?.queryItems = [
            URLQueryItem(name: "daddr", value: address),
            URLQueryItem(name: "dirflg", value: "d")
        ]
        
        guard let url = components?.url else { return }
        openURL(url)
    }
}
