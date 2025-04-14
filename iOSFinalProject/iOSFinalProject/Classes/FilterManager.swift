//
//  FilterManager.swift
//  iOSFinalProject
//
//  Created by Carlos Castro on 2025-04-12.
//

import Foundation
import MapKit

class FilterManager {
    var allPOIs: [POI] = []
    
    func filter(by interests: [String]) -> [POI] {
        return allPOIs.filter { poi in
            interests.contains(poi.category)
        }
    }
}

