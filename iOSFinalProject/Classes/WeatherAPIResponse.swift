//
//  WeatherViewController.swift
//  iOSFinalProject
//
//  Created by Annette Sookraj on 2025-03-28.
//

import UIKit
import CoreLocation
import MapKit

struct WeatherAPIResponse: Decodable {
    let location: Location
    let current: Current

    struct Location: Decodable {
        let name: String
        let region: String
        let country: String
    }

    struct Current: Decodable {
        let temp_c: Double
        let condition: Condition
    }

    struct Condition: Decodable {
        let text: String
        let icon: String
    }
}

