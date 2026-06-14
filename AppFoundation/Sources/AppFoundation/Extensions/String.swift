//
//  File.swift
//  AppFoundation
//
//  Created by 纪洪波 on 2026/6/14.
//

import Foundation

public extension String {
    var normalizedAddress: String {
        trimmingCharacters(in: .whitespacesAndNewlines).localizedLowercase
    }
}
