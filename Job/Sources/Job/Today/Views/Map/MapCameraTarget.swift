//
//  TodayMapCameraTarget.swift
//  Job
//
//  Created by 纪洪波 on 2026/6/14.
//

import MapKit
import Model
import SwiftUI

enum MapCameraTarget {
    case automatic
    case region(MKCoordinateRegion)
    case rect(MKMapRect)
    
    init(destinations: [Job], currentLocationCoordinate: CLLocationCoordinate2D?) {
        let coordinates = destinations.map(\.coordinate) + [currentLocationCoordinate].compactMap { $0 }
        guard !coordinates.isEmpty else {
            self = .automatic
            return
        }
        
        if coordinates.count == 1, let coordinate = coordinates.first {
            self = .region(
                MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
                )
            )
            return
        }
        
        let mapRect = coordinates.reduce(MKMapRect.null) { partialResult, coordinate in
            let point = MKMapPoint(coordinate)
            let pointRect = MKMapRect(x: point.x, y: point.y, width: 1, height: 1)
            return partialResult.union(pointRect)
        }
        
        self = .rect(mapRect.insetBy(dx: -mapRect.width * 0.2, dy: -mapRect.height * 0.2))
    }
    
    var position: MapCameraPosition {
        switch self {
        case .automatic:
            .automatic
        case .region(let region):
            .region(region)
        case .rect(let rect):
            .rect(rect)
        }
    }
    
    func camera(using proxy: MapProxy, fallback: MapCamera) -> MapCamera {
        switch self {
        case .automatic:
            fallback
        case .region(let region):
            proxy.camera(framing: region)
        case .rect(let rect):
            proxy.camera(framing: rect)
        }
    }
}
