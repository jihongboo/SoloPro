import SwiftUI

struct LocationUnavailableView: View {
    @Environment(\.openURL) private var openURL

    let viewModel: LocationsModel

    var body: some View {
        if viewModel.cleanSearchText.isEmpty {
            ContentUnavailableView {
                Label("Search for a Location", systemImage: "mappin.and.ellipse")
            } description: {
                Text(locationUnavailableDescription)
            } actions: {
                if !viewModel.hasAuthorization {
                    Button(locationPermissionActionTitle) {
                        handleLocationPermissionAction()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        } else if let errorMessage = viewModel.errorMessage {
            ContentUnavailableView(
                "Location Search Failed",
                systemImage: "exclamationmark.triangle",
                description: Text(errorMessage)
            )
        } else if viewModel.completions.isEmpty && !viewModel.isSearching {
            ContentUnavailableView(
                "No Suggestions",
                systemImage: "magnifyingglass",
                description: Text("Try a more specific street address or place name.")
            )
        }
    }
}

private extension LocationUnavailableView {
    var locationUnavailableDescription: String {
        switch viewModel.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            "Enter an address to see suggested locations."
        case .denied, .restricted:
            "Enter an address to see suggested locations. Location access is off, so nearby results may be less relevant."
        case .notDetermined:
            "Enter an address to see suggested locations. Enable location access for more relevant nearby results."
        @unknown default:
            "Enter an address to see suggested locations."
        }
    }
    
    var locationPermissionActionTitle: String {
        switch viewModel.authorizationStatus {
        case .denied, .restricted:
            "Open Settings"
        default:
            "Enable Location"
        }
    }
    
    func handleLocationPermissionAction() {
        switch viewModel.authorizationStatus {
        case .notDetermined:
            viewModel.requestAuthorization()
        case .denied, .restricted:
            guard let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
            openURL(settingsURL)
        default:
            break
        }
    }
}
