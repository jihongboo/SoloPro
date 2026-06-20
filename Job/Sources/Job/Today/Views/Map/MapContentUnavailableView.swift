//
//  MapContentUnavailableView.swift
//  Job
//
//  Created by 纪洪波 on 2026/6/14.
//

import SwiftUI

struct MapContentUnavailableView: View {
    let mapModel: TodayDestinationsMapModel
    
    @Environment(\.openURL) private var openURL
    
    var body: some View {
        if mapModel.destinationJobs.isEmpty {
            ContentUnavailableView(
                "No Active Destinations",
                systemImage: "map",
            )
            .background(Color(uiColor: .secondarySystemGroupedBackground))
        } else if !mapModel.hasAuthorization {
            ContentUnavailableView {
                Label(locationPermissionTitle, systemImage: "location.circle")
            } description: {
                Text(locationPermissionDescription)
            } actions: {
                Button(locationPermissionActionTitle, action: requestLocationAuthorization)
                    .buttonStyle(.borderedProminent)
            }
            .background(Color(uiColor: .secondarySystemGroupedBackground))
        }
    }
}

#Preview {
    MapContentUnavailableView(mapModel: TodayDestinationsMapModel())
}

private extension MapContentUnavailableView {
    func requestLocationAuthorization() {
        guard mapModel.requestAuthorization(),
              let settingsURL = URL(string: UIApplication.openSettingsURLString) else { return }
        openURL(settingsURL)
    }
    
    var locationPermissionTitle: String {
        switch mapModel.authorizationStatus {
        case .denied, .restricted:
            "Location Access Disabled"
        default:
            "Location Access Needed"
        }
    }
    
    var locationPermissionDescription: String {
        switch mapModel.authorizationStatus {
        case .denied, .restricted:
            "Enable location access in Settings to show where you are relative to today's destinations."
        default:
            "Allow location access to show your current position on the map."
        }
    }
    
    var locationPermissionActionTitle: String {
        switch mapModel.authorizationStatus {
        case .denied, .restricted:
            "Open Settings"
        default:
            "Allow Location"
        }
    }
}
