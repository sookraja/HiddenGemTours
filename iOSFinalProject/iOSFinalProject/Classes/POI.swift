//
//  POI.swift
//  iOSFinalProject
//
//  Created by Carlos Castro on 2025-04-12.
//


import Foundation
import CoreLocation

// Codable-compatible coordinate
struct CodableCoordinate: Codable {
    let latitude: Double
    let longitude: Double

    var clCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    init(from coordinate: CLLocationCoordinate2D) {
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
    }

    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}

// Main POI struct
struct POI: Codable {
    let name: String
    let coordinate: CodableCoordinate
    let category: String
    var routeToNext: [CodableCoordinate]? = nil
    var orderIndex: Int? = nil // Optional ordering if needed
}

