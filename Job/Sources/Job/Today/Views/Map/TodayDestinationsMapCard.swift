import CoreLocation
import Foundation
import MapKit
import SwiftUI
import Model

struct TodayDestinationsMapCard: View {
    let jobs: [Job]
    let routeDestinationJob: Job?
    
    @State private var mapModel = TodayDestinationsMapModel()
    
    var body: some View {
        MapReader { proxy in
            Map {
                if let currentRoute = mapModel.currentRoute {
                    MapPolyline(currentRoute)
                        .stroke(mapModel.routeTint, lineWidth: 4)
                }
                
                UserAnnotation()
                
                ForEach(mapModel.destinationJobs) { destination in
                    Marker(
                        destination.address,
                        coordinate: destination.coordinate
                    )
                    .tint(destination.status.tint)
                }
            }
            .mapCameraKeyframeAnimator(trigger: mapModel.cameraAnimationTrigger) { currentCamera in
                let targetCamera = mapModel.cameraTarget.camera(using: proxy, fallback: currentCamera)
                KeyframeTrack(\.centerCoordinate) {
                    CubicKeyframe(targetCamera.centerCoordinate, duration: 0.45)
                }
                KeyframeTrack(\.distance) {
                    CubicKeyframe(targetCamera.distance, duration: 0.45)
                }
                KeyframeTrack(\.heading) {
                    CubicKeyframe(targetCamera.heading, duration: 0.45)
                }
                KeyframeTrack(\.pitch) {
                    CubicKeyframe(targetCamera.pitch, duration: 0.45)
                }
            }
            .mapStyle(.standard(elevation: .flat))
            .mapControlVisibility(.hidden)
            .overlay(alignment: .topLeading) {
                MapInformationView(mapModel: mapModel)
                    .padding(8)
            }
            .overlay {
                MapContentUnavailableView(mapModel: mapModel)
            }
        }
        .frame(height: 220)
        .clipShape(.containerRelative)
        .task(id: requestSignature, loadDestinations)
        .task(mapModel.configureLocationAuthorizationTracking)
    }

}

#Preview {
    TodayDestinationsMapCard(jobs: .mock, routeDestinationJob: .mock)
}

private extension TodayDestinationsMapCard {
    
    private var requestSignature: String {
        let jobIDs = jobs.map(\.id.uuidString).joined(separator: "|")
        let routeDestinationJobID = routeDestinationJob?.id.uuidString ?? "nil"
        return [jobIDs, routeDestinationJobID].joined(separator: "##")
    }
    
    func loadDestinations() async {
        await mapModel.load(jobs: jobs, routeDestinationJob: routeDestinationJob)
    }
}

extension Job {
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
