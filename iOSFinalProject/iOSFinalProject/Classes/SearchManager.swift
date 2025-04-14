//
//  SearchManager.swift
//  iOSFinalProject
//
//  Created by Carlos Castro on 2025-04-12.
//


import Foundation
import MapKit

class SearchManager {
    func search(for query: String, region: MKCoordinateRegion, completion: @escaping ([MKMapItem]) -> Void) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = region
        
        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let items = response?.mapItems, error == nil else {
                completion([])
                return
            }
            completion(items)
        }
    }
}
