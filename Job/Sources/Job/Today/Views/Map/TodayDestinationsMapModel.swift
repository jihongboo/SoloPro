//
//  TodayDestinationsMapModel.swift
//  Job
//
//  Created by 纪洪波 on 2026/6/14.
//

import CoreLocation
import MapKit
import Model
import Observation
import SwiftUI
import AppFoundation

@MainActor
@Observable
final class TodayDestinationsMapModel: NSObject {
    var currentRoute: MKRoute?
    var cameraTarget: MapCameraTarget = .automatic
    var cameraAnimationTrigger = 0
    var locationAuthorizationStatus = CLLocationManager().authorizationStatus
    var currentLocationCoordinate: CLLocationCoordinate2D?
    private(set) var destinationJobs: [Job] = []
    
    @ObservationIgnored private let locationManager = CLLocationManager()
    @ObservationIgnored private var didConfigureLocationTracking = false
    @ObservationIgnored private var routeDestinationJob: Job?
    
    var hasLocationAuthorization: Bool {
        isPreview || locationAuthorizationStatus == .authorizedAlways || locationAuthorizationStatus == .authorizedWhenInUse
    }
    
    var routeTint: Color {
        routeDestinationJob?.status.tint ?? .accentColor
    }
    
    func load(jobs: [Job], routeDestinationJob: Job?) async {
        updateJobs(jobs, routeDestinationJob: routeDestinationJob)
        updateCameraPosition()
        await updateRoute()
    }
    
    func configureLocationAuthorizationTracking() async {
        guard !isPreview, !didConfigureLocationTracking else { return }
        didConfigureLocationTracking = true
        
        locationManager.delegate = self
        locationAuthorizationStatus = locationManager.authorizationStatus
        currentLocationCoordinate = locationManager.location?.coordinate
        requestCurrentLocationIfAuthorized()
    }
    
    func requestLocationAuthorization() -> Bool {
        switch locationAuthorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            return false
        case .denied, .restricted:
            return true
        default:
            requestCurrentLocationIfAuthorized()
            return false
        }
    }
    
    private func updateRoute() async {
        guard let currentLocationCoordinate,
              let routeDestinationJob,
              destinationJobs.contains(where: { $0.id == routeDestinationJob.id }) else {
            currentRoute = nil
            return
        }
        
        guard let route = try? await route(from: currentLocationCoordinate, to: routeDestinationJob.coordinate) else {
            currentRoute = nil
            return
        }
        
        guard !Task.isCancelled else { return }
        currentRoute = route
    }
    
    private func route(from currentLocationCoordinate: CLLocationCoordinate2D, to destinationCoordinate: CLLocationCoordinate2D) async throws -> MKRoute? {
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
    
    private func updateCameraPosition() {
        let target = MapCameraTarget(destinations: destinationJobs, currentLocationCoordinate: currentLocationCoordinate)
        cameraTarget = target
        cameraAnimationTrigger += 1
    }
    
    private func requestCurrentLocationIfAuthorized() {
        guard hasLocationAuthorization else { return }
        
        locationManager.requestLocation()
    }
    
    private func updateJobs(_ jobs: [Job], routeDestinationJob: Job?) {
        destinationJobs = jobs
            .filter { !$0.status.isEnded }
            .sorted {
                $0.address.localizedCaseInsensitiveCompare($1.address) == .orderedAscending
            }
        self.routeDestinationJob = routeDestinationJob
    }
}

extension TodayDestinationsMapModel: CLLocationManagerDelegate {
    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        Task { @MainActor [weak self] in
            guard let self else { return }
            locationAuthorizationStatus = status
            requestCurrentLocationIfAuthorized()
        }
    }
    
    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.last?.coordinate else { return }
        Task { @MainActor [weak self] in
            guard let self else { return }
            currentLocationCoordinate = coordinate
            updateCameraPosition()
            await updateRoute()
        }
    }
    
    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
}

private extension JobStatus {
    var isEnded: Bool {
        self == .completed || self == .canceled
    }
}
