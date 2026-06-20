//
//  LocationSuggestionRow.swift
//  Widgets
//
//  Created by 纪洪波 on 6/20/26.
//

import SwiftUI
import MapKit

struct LocationView: View {
    let completion: MKLocalSearchCompletion

    var body: some View {
        Label {
            VStack(alignment: .leading, spacing: 4) {
                Text(completion.title)
                    .font(.headline)
                    .foregroundStyle(.primary)

                if !completion.subtitle.isEmpty {
                    Text(completion.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .padding(.vertical, 4)
        } icon: {
            Image(systemName: "mappin.circle.fill")
                .font(.title2)
                .foregroundStyle(.blue)
        }
    }
}

extension MKLocalSearchCompletion {
    var formattedAddress: String {
        [title, subtitle]
            .filter { !$0.isEmpty }
            .joined(separator: ", ")
    }
}
