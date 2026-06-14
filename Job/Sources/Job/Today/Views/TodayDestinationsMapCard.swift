import CoreLocation
import MapKit
import SwiftUI
import Model

struct TodayDestinationsMapCard: View {
    let jobs: [Job]

    @State private var destinations: [TodayMapDestination] = []
    @State private var unresolvedAddressCount = 0
    @State private var isLoadingDestinations = false
    @State private var cameraPosition: MapCameraPosition = .automatic

    private var destinationRequests: [TodayMapDestinationRequest] {
        let groupedJobs = Dictionary(grouping: jobsWithAddresses, by: { $0.address.normalizedAddress })

        return groupedJobs.values
            .compactMap { jobs in
                guard let firstJob = jobs.sorted(by: { $0.date < $1.date }).first else { return nil }
                return TodayMapDestinationRequest(
                    address: firstJob.address.trimmingCharacters(in: .whitespacesAndNewlines),
                    jobCount: jobs.count,
                    status: jobs.destinationStatus
                )
            }
            .sorted { $0.address.localizedCaseInsensitiveCompare($1.address) == .orderedAscending }
    }

    private var jobsWithAddresses: [Job] {
        jobs.filter { !$0.address.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    }

    private var requestSignature: String {
        destinationRequests
            .map { "\($0.address)|\($0.jobCount)|\($0.status.rawValue)" }
            .joined(separator: "||")
    }

    var body: some View {
        mapContent
            .frame(height: 220)
            .clipShape(.containerRelative)
            .task(id: requestSignature, loadDestinations)
    }

    @ViewBuilder
    private var mapContent: some View {
        Map(position: $cameraPosition) {
            ForEach(destinations) { destination in
                Marker(
                    destination.title,
                    coordinate: destination.coordinate
                )
                .tint(destination.status.tint)
            }
        }
        .mapStyle(.standard(elevation: .flat))
        .mapControlVisibility(.hidden)
        .overlay(alignment: .topLeading) {
            mapLegend
                .padding(8)
        }
        .overlay(alignment: .bottomLeading) {
            if unresolvedAddressCount > 0 {
                Text("\(unresolvedAddressCount) address unresolved")
                    .font(.caption2)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 5)
                    .background(.regularMaterial, in: Capsule())
                    .padding(8)
            }
        }
        .overlay {
            if true { //d estinationRequests.isEmpty {
                ContentUnavailableView(
                    "No Destinations",
                    systemImage: "map",
                    description: Text("Jobs with addresses will appear on the map.")
                )
                .background(.background)
            } else if destinations.isEmpty {
                ContentUnavailableView(
                    isLoadingDestinations ? "Loading Map" : "Map Unavailable",
                    systemImage: isLoadingDestinations ? "location.magnifyingglass" : "exclamationmark.magnifyingglass",
                    description: Text(isLoadingDestinations ? "Finding today's destinations." : "No job addresses could be located.")
                )
                .background(.background)
            }
        }
    }

    private var mapLegend: some View {
        HStack(spacing: 8) {
            legendItem("Completed", tint: JobStatus.completed.tint)
            legendItem("Open", tint: JobStatus.scheduled.tint)
        }
        .font(.caption2.weight(.medium))
        .padding(4)
        .glassEffect(in: .capsule)
    }

    private func legendItem(_ title: String, tint: Color) -> some View {
        HStack(spacing: 4) {
            Circle()
                .fill(tint)
                .frame(width: 6, height: 6)

            Text(title)
                .foregroundStyle(tint)
        }
    }

    private var destinationSummary: String {
        if destinationRequests.isEmpty {
            "No addresses scheduled today"
        } else if unresolvedAddressCount > 0 {
            "\(destinations.count) of \(destinationRequests.count) mapped"
        } else {
            "\(destinationRequests.count) stops today"
        }
    }

    private func loadDestinations() async {
        let requests = destinationRequests
        guard !requests.isEmpty else {
            destinations = []
            unresolvedAddressCount = 0
            cameraPosition = .automatic
            return
        }

        isLoadingDestinations = true
        defer { isLoadingDestinations = false }

        var resolvedDestinations: [TodayMapDestination] = []

        for request in requests {
            guard !Task.isCancelled else { return }

            if let coordinate = try? await coordinate(for: request.address) {
                resolvedDestinations.append(
                    TodayMapDestination(
                        address: request.address,
                        jobCount: request.jobCount,
                        status: request.status,
                        coordinate: coordinate
                    )
                )
            }
        }

        guard !Task.isCancelled else { return }

        destinations = resolvedDestinations
        unresolvedAddressCount = requests.count - resolvedDestinations.count
        cameraPosition = resolvedDestinations.cameraPosition
    }

    private func coordinate(for address: String) async throws -> CLLocationCoordinate2D? {
        guard let request = MKGeocodingRequest(addressString: address) else { return nil }

        let mapItems = try await request.mapItems
        return mapItems.first?.location.coordinate
    }
}

#Preview {
    List {
        Section {
            TodayDestinationsMapCard(jobs: .mock)
        }
    }
}

private struct TodayMapDestinationRequest: Identifiable {
    let address: String
    let jobCount: Int
    let status: JobStatus

    var id: String { address.normalizedAddress }
}

private struct TodayMapDestination: Identifiable {
    let address: String
    let jobCount: Int
    let status: JobStatus
    let coordinate: CLLocationCoordinate2D

    var id: String { address.normalizedAddress }

    var title: String {
        if jobCount == 1 {
            address
        } else {
            "\(address) (\(jobCount) jobs)"
        }
    }
}

private extension Array where Element == Job {
    var destinationStatus: JobStatus {
        if allSatisfy({ $0.status == .completed }) {
            return .completed
        } else if contains(where: { $0.status == .inProgress }) {
            return .inProgress
        } else {
            return .scheduled
        }
    }
}

private extension Array where Element == TodayMapDestination {
    var cameraPosition: MapCameraPosition {
        guard !isEmpty else { return .automatic }

        if count == 1, let coordinate = first?.coordinate {
            return .region(
                MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
                )
            )
        }

        let mapRect = reduce(MKMapRect.null) { partialResult, destination in
            let point = MKMapPoint(destination.coordinate)
            let pointRect = MKMapRect(x: point.x, y: point.y, width: 1, height: 1)
            return partialResult.union(pointRect)
        }

        return .rect(mapRect.insetBy(dx: -mapRect.width * 0.2, dy: -mapRect.height * 0.2))
    }
}

private extension String {
    var normalizedAddress: String {
        trimmingCharacters(in: .whitespacesAndNewlines).localizedLowercase
    }
}
