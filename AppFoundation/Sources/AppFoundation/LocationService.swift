import CoreLocation
import Observation

@Observable
public final class LocationService: NSObject {
    public private(set) var authorizationStatus: CLAuthorizationStatus
    public private(set) var coordinate: CLLocationCoordinate2D?
    
    @ObservationIgnored private let locationManager = CLLocationManager()
    
    public var hasAuthorization: Bool {
        authorizationStatus == .authorizedAlways || authorizationStatus == .authorizedWhenInUse
    }
    
    public override init() {
        authorizationStatus = locationManager.authorizationStatus
        coordinate = locationManager.location?.coordinate
        super.init()
        locationManager.delegate = self
    }
    
    @discardableResult
    public func requestAuthorization() -> Bool {
        switch authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            return false
        case .denied, .restricted:
            return true
        default:
            requestLocationIfAuthorized()
            return false
        }
    }
    
    public func requestLocationIfAuthorized() {
        guard hasAuthorization else { return }
        
        locationManager.requestLocation()
    }
}

extension LocationService: CLLocationManagerDelegate {
    nonisolated public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        authorizationStatus = status
        requestLocationIfAuthorized()
    }
    
    nonisolated public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.last?.coordinate else { return }
        self.coordinate = coordinate
    }
    
    nonisolated public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
}
