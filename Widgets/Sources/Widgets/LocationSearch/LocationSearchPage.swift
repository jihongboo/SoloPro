import MapKit
import Observation
import SwiftUI

public struct LocationSearchPage: View {
    @Environment(\.dismiss) private var dismiss

    @Binding var address: String
    @Binding var latitude: Double?
    @Binding var longitude: Double?
    let requiresCoordinate: Bool

    @State private var searchText = ""
    @State private var searchModel = LocationSearchModel()
    @State private var isResolvingSearchText = false
    @FocusState private var isSearchFocused: Bool

    private var canConfirm: Bool {
        !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
        !address.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    public init(
        address: Binding<String>,
        latitude: Binding<Double?>,
        longitude: Binding<Double?>,
        requiresCoordinate: Bool = false
    ) {
        _address = address
        _latitude = latitude
        _longitude = longitude
        self.requiresCoordinate = requiresCoordinate
    }

    public var body: some View {
        NavigationStack {
            Group {
                if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    ContentUnavailableView(
                        "Search for a Location",
                        systemImage: "mappin.and.ellipse",
                        description: Text("Enter an address to see suggested locations.")
                    )
                } else if let errorMessage = searchModel.errorMessage {
                    ContentUnavailableView(
                        "Location Search Failed",
                        systemImage: "exclamationmark.triangle",
                        description: Text(errorMessage)
                    )
                } else if searchModel.completions.isEmpty && !searchModel.isSearching {
                    ContentUnavailableView(
                        "No Suggestions",
                        systemImage: "magnifyingglass",
                        description: Text("Try a more specific street address or place name.")
                    )
                } else {
                    List(searchModel.completions) { completion in
                        Button {
                            select(completion)
                        } label: {
                            LocationSuggestionRow(completion: completion)
                        }
                        .buttonStyle(.plain)
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        confirmSearchText()
                    } label: {
                        if isResolvingSearchText {
                            ProgressView()
                        } else {
                            Image(systemName: "checkmark")
                        }
                    }
                    .disabled(!canConfirm || isResolvingSearchText)
                }
            }
            .safeAreaInset(edge: .bottom) {
                searchBar
            }
            .onAppear {
                searchText = address
                searchModel.updateSearchText(address)
                isSearchFocused = true
            }
            .onChange(of: searchText) { _, newValue in
                searchModel.updateSearchText(newValue)
            }
        }
    }

    private var searchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)

            TextField("Search or Enter Address", text: $searchText)
                .textContentType(.fullStreetAddress)
                .focused($isSearchFocused)
                .submitLabel(.done)
                .onSubmit(confirmSearchText)

            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Clear Address")
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.thinMaterial, in: Capsule())
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 10)
        .background(.background)
    }
}

#Preview {
    @Previewable @State var address = ""
    @Previewable @State var latitude: Double?
    @Previewable @State var longitude: Double?

    LocationSearchPage(
        address: $address,
        latitude: $latitude,
        longitude: $longitude
    )
}

private extension LocationSearchPage {
    private func select(_ completion: LocationCompletion) {
        address = completion.formattedAddress

        let search = MKLocalSearch(request: MKLocalSearch.Request(completion: completion.mapCompletion))
        search.start { response, _ in
            Task { @MainActor in
                guard let coordinate = response?.mapItems.first?.location.coordinate else {
                    latitude = nil
                    longitude = nil
                    searchModel.errorMessage = "No coordinates were found for this location. Try a more specific address."
                    if !requiresCoordinate {
                        dismiss()
                    }
                    return
                }

                latitude = coordinate.latitude
                longitude = coordinate.longitude
                dismiss()
            }
        }
    }

    private func confirmSearchText() {
        let cleanAddress = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleanAddress.isEmpty else {
            dismiss()
            return
        }

        guard requiresCoordinate else {
            address = cleanAddress
            latitude = nil
            longitude = nil
            dismiss()
            return
        }

        Task {
            await resolveAndConfirm(cleanAddress)
        }
    }

    @MainActor
    private func resolveAndConfirm(_ cleanAddress: String) async {
        isResolvingSearchText = true
        defer { isResolvingSearchText = false }

        guard let request = MKGeocodingRequest(addressString: cleanAddress) else {
            searchModel.errorMessage = "Enter a more specific address."
            return
        }

        do {
            guard let coordinate = try await request.mapItems.first?.location.coordinate else {
                searchModel.errorMessage = "No coordinates were found for this address. Try a more specific address."
                return
            }

            address = cleanAddress
            latitude = coordinate.latitude
            longitude = coordinate.longitude
            dismiss()
        } catch {
            searchModel.errorMessage = error.localizedDescription
        }
    }
}

private struct LocationSuggestionRow: View {
    let completion: LocationCompletion

    var body: some View {
        Label {
            VStack(alignment: .leading, spacing: 4) {
                Text(completion.title)
                    .font(.headline)
                    .foregroundStyle(.primary)

                if !completion.subtitle.isEmpty {
                    Text(completion.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.vertical, 4)
        } icon: {
            Image(systemName: "mappin.circle.fill")
                .font(.title2)
                .foregroundStyle(.blue)
        }
    }
}

private struct LocationCompletion: Identifiable {
    let title: String
    let subtitle: String
    let mapCompletion: MKLocalSearchCompletion

    var id: String {
        formattedAddress
    }

    var formattedAddress: String {
        [title, subtitle]
            .filter { !$0.isEmpty }
            .joined(separator: ", ")
    }
}

@Observable
private final class LocationSearchModel: NSObject, MKLocalSearchCompleterDelegate {
    var completions: [LocationCompletion] = []
    var isSearching = false
    var errorMessage: String?

    @ObservationIgnored private let completer = MKLocalSearchCompleter()

    override init() {
        super.init()
        completer.delegate = self
        completer.resultTypes = [.address, .pointOfInterest]
    }

    func updateSearchText(_ text: String) {
        let cleanText = text.trimmingCharacters(in: .whitespacesAndNewlines)

        guard !cleanText.isEmpty else {
            completions = []
            isSearching = false
            errorMessage = nil
            return
        }

        isSearching = true
        errorMessage = nil
        completer.queryFragment = cleanText
    }

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        completions = completer.results.map {
            LocationCompletion(title: $0.title, subtitle: $0.subtitle, mapCompletion: $0)
        }
        isSearching = false
        errorMessage = nil
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        completions = []
        isSearching = false
        errorMessage = error.localizedDescription
    }
}
