//
//  LocationSearchModel.swift
//  Widgets
//
//  Created by 纪洪波 on 6/20/26.
//

import AppFoundation
import MapKit
import SwiftUI

private enum LocationResolutionError: LocalizedError {
    case coordinateNotFound

    var errorDescription: String? {
        switch self {
        case .coordinateNotFound:
            "No coordinates were found for this location. Try a more specific address."
        }
    }
}

@MainActor
@Observable
final class LocationsModel: NSObject {
    var searchText = "" {
        didSet {
            updateSearchText(searchText)
        }
    }
    var completions: [MKLocalSearchCompletion] = []
    var isSearching = false
    var isResolvingLocation = false
    var errorMessage: String?

    var authorizationStatus: CLAuthorizationStatus {
        locationService.authorizationStatus
    }

    var cleanSearchText: String {
        searchText.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var hasAuthorization: Bool {
        locationService.hasAuthorization
    }

    @ObservationIgnored private let completer = MKLocalSearchCompleter()
    @ObservationIgnored private let locationService = LocationService()
    @ObservationIgnored private var selectedCompletionSearch: MKLocalSearch?

    override init() {
        super.init()
        completer.delegate = self
        completer.resultTypes = [.address, .pointOfInterest]
        updateCompleterRegion(with: locationService.coordinate)
        locationService.requestLocationIfAuthorized()
    }

    func requestAuthorization() {
        locationService.requestAuthorization()
    }

    func resolveCoordinate(for completion: MKLocalSearchCompletion) async throws -> CLLocationCoordinate2D {
        selectedCompletionSearch?.cancel()

        let search = MKLocalSearch(request: MKLocalSearch.Request(completion: completion))
        selectedCompletionSearch = search
        isResolvingLocation = true

        do {
            let coordinate = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<CLLocationCoordinate2D, Error>) in
                search.start { response, error in
                    if let error {
                        continuation.resume(throwing: error)
                        return
                    }

                    guard let coordinate = response?.mapItems.first?.location.coordinate else {
                        continuation.resume(throwing: LocationResolutionError.coordinateNotFound)
                        return
                    }

                    continuation.resume(returning: coordinate)
                }
            }

            errorMessage = nil
            selectedCompletionSearch = nil
            isResolvingLocation = false
            return coordinate
        } catch {
            selectedCompletionSearch = nil
            isResolvingLocation = false
            throw error
        }
    }
}

extension LocationsModel: @preconcurrency MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        completions = completer.results
        isSearching = false
        errorMessage = nil
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        completions = []
        isSearching = false
        errorMessage = error.localizedDescription
    }
}

private extension LocationsModel {
    func updateCompleterRegion(with coordinate: CLLocationCoordinate2D?) {
        guard let coordinate else { return }

        completer.region = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: 50_000,
            longitudinalMeters: 50_000
        )
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
        updateCompleterRegion(with: locationService.coordinate)
        completer.queryFragment = cleanText
    }
}
