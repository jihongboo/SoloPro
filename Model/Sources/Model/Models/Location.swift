//
//  File.swift
//  Model
//
//  Created by 纪洪波 on 6/20/26.
//

import Foundation

public struct Location {
    public let address: String
    public let latitude: Double
    public let longitude: Double
    
    public init(address: String, latitude: Double, longitude: Double) {
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
    }
}
