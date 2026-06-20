//
//  CLLocationCoordinate2D.swift
//  AppFoundation
//
//  Created by 纪洪波 on 6/20/26.
//

import MapKit

extension CLLocationCoordinate2D: @retroactive Equatable {
    public static func == (lhs: borrowing CLLocationCoordinate2D, rhs: borrowing CLLocationCoordinate2D) -> Bool {
        guard lhs.latitude == rhs.latitude else {
            return false
        }

        return lhs.longitude == rhs.longitude
    }
}
