//
//  TodayDestinationsMapModel.swift
//  Job
//
//  Created by 纪洪波 on 2026/6/14.
//

import AppFoundation
import CoreLocation
import MapKit
import Model
import Observation
import SwiftUI

@MainActor
@Observable
final class TodayDestinationsMapModel: NSObject {
    private(set) var route: MKRoute?
    private(set) var cameraTarget: MapCameraTarget = .automatic
    private(set) var cameraAnimationTrigger = 0
    private(set) var destinationJobs: [Job] = []

    var coordinate: CLLocationCoordinate2D? {
        locationService.coordinate
    }

    var authorizationStatus: CLAuthorizationStatus {
        locationService.authorizationStatus
    }
    
    var hasAuthorization: Bool {
        isPreview || locationService.hasAuthorization
    }
    
    var routeTint: Color {
        routeDestinationJob?.status.tint ?? .accentColor
    }
    
    @ObservationIgnored private let locationService = LocationService()
    @ObservationIgnored private var routeDestinationJob: Job?
    
    func load(jobs: [Job], routeDestinationJob: Job?) async {
        updateJobs(jobs, routeDestinationJob: routeDestinationJob)
        updateCameraPosition()
        await updateRoute()
    }
    
    func requestLocationIfAuthorized() {
        locationService.requestLocationIfAuthorized()
    }
    
    @discardableResult
    func requestAuthorization() -> Bool {
        locationService.requestAuthorization()
    }

    func handleCoordinateChange() async {
        updateCameraPosition()
        await updateRoute()
    }
}

private extension TodayDestinationsMapModel {
    func updateRoute() async {
        guard let coordinate,
              let routeDestinationJob,
              destinationJobs.contains(where: { $0.id == routeDestinationJob.id }) else {
            route = nil
            return
        }
        
        guard let route = try? await route(from: coordinate, to: routeDestinationJob.coordinate) else {
            route = nil
            return
        }
        
        guard !Task.isCancelled else { return }
        self.route = route
    }
    
    func route(from currentLocationCoordinate: CLLocationCoordinate2D, to destinationCoordinate: CLLocationCoordinate2D) async throws -> MKRoute? {
        let request = MKDirections.Request()
        request.source = MKMapItem(
            location: CLLocation(latitude: currentLocationCoordinate.latitude, longitude: currentLocationCoordinate.longitude),
            address: nil
        )
        request.destination = MKMapItem(
            location: CLLocation(latitude: destinationCoordinate.latitude, longitude: destinationCoordinate.longitude),
            address: nil
        )
        request.transportType = .automobile
        
        let response = try await MKDirections(request: request).calculate()
        return response.routes.first
    }
    
    func updateCameraPosition() {
        let target = MapCameraTarget(destinations: destinationJobs, currentLocationCoordinate: coordinate)
        cameraTarget = target
        cameraAnimationTrigger += 1
    }
    
    func updateJobs(_ jobs: [Job], routeDestinationJob: Job?) {
        destinationJobs = jobs
            .filter { !$0.status.isEnded }
            .sorted {
                $0.address.localizedCaseInsensitiveCompare($1.address) == .orderedAscending
            }
        self.routeDestinationJob = routeDestinationJob
    }
}

private extension JobStatus {
    var isEnded: Bool {
        self == .completed || self == .canceled
    }
}
