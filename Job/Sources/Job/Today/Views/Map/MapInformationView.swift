//
//  MapInformationView.swift
//  Job
//
//  Created by 纪洪波 on 2026/6/14.
//

import MapKit
import SwiftUI

struct MapInformationView: View {
    let mapModel: TodayDestinationsMapModel
    
    var body: some View {
        if let route = mapModel.currentRoute {
            let distance = Measurement(value: route.distance, unit: UnitLength.meters)
                .converted(to: .miles)
            let distancePrecision: NumberFormatStyleConfiguration.Precision = distance.value < 10 ? .fractionLength(1) : .fractionLength(0)
            let distanceFormat: Measurement<UnitLength>.FormatStyle = .measurement(
                width: .abbreviated,
                usage: .asProvided,
                numberFormatStyle: .number.precision(distancePrecision)
            )
            let expectedTravelTime = Duration.seconds(Int64(max(60, route.expectedTravelTime).rounded()))
            
            HStack(spacing: 6) {
                Circle()
                    .fill(mapModel.routeTint)
                    .frame(width: 6, height: 6)
                
                Text("\(distance, format: distanceFormat) · \(expectedTravelTime, format: MapInformationView.expectedTravelTimeFormat)")
                    .foregroundStyle(.primary)
            }
            .font(.caption2.weight(.semibold))
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .background(.regularMaterial, in: Capsule())
        }
    }
}

private extension MapInformationView {
    static let expectedTravelTimeFormat: Duration.UnitsFormatStyle = .units(
        allowed: [.hours, .minutes],
        width: .abbreviated,
        maximumUnitCount: 2
    )
}
