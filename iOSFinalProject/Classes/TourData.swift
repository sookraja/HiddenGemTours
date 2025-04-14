//
//  TourData.swift
//  iOSFinalProject
//
//  Created by Carlos Castro on 2025-04-12.
//  Secondary Author: Edgar Ponce
//


import Foundation
import CoreLocation

class TourData: NSObject, Codable {
    var id: Int?
    var name: String?
    var latitude: Double?
    var longitude: Double?
    var tourId: Int?
    var tourName: String?
    var orderIndex: Int?

    func coordinate() -> CLLocationCoordinate2D? {
        guard let lat = latitude, let lon = longitude else { return nil }
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
}
