//
//  TourDetailViewController.swift
//  iOSFinalProject
//
//  Created by Carlos Castro on 2025-04-12.
//

import UIKit
import MapKit
import CoreLocation

class TourDetailViewController: UIViewController, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tourNameLabel: UILabel!
    @IBOutlet weak var beginTourButton: UIButton!
    @IBOutlet weak var myTableView: UITableView!

    var tourEntity: TourEntity!
    let tourManager = TourManager()
    var tourStops: [TourData] = []
    var firstCoord: CLLocationCoordinate2D!
    var currentStopIndex = 0
    
  
    let locationManager = CLLocationManager()
    let regionRadius: CLLocationDistance = 550
    var routeSteps  = [" "] as NSMutableArray
    var distSteps =  [" "] as NSMutableArray
    var detailSteps =  [" "] as NSMutableArray

    var selectedCity: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        myTableView.delegate = self
        myTableView.dataSource = self
        

        locationManager.requestWhenInUseAuthorization()
        mapView.showsUserLocation = true
        locationManager.startUpdatingLocation()
    
        showTour()
    }
    
  
    func calculateDirectionsToStop(stopIndex: Int) {
        guard stopIndex < tourStops.count else { return }
        currentStopIndex = stopIndex
        
        let stop = tourStops[stopIndex]
        guard let stopLat = stop.latitude, let stopLong = stop.longitude else { return }
        let stopCoordinates = CLLocationCoordinate2D(latitude: stopLat, longitude: stopLong)
        
        // Get user's current location
        guard let userLocation = mapView.userLocation.location else { return }
      
        mapView.removeOverlays(mapView.overlays)
        
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: userLocation.coordinate, addressDictionary: nil))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: stopCoordinates, addressDictionary: nil))
        request.requestsAlternateRoutes = false
        request.transportType = .walking
        
        let directions = MKDirections(request: request)
        directions.calculate(completionHandler: { [unowned self] response, error in
            guard let response = response, let route = response.routes.first else {
                print("Error calculating directions: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            self.mapView.addOverlay(route.polyline, level: .aboveRoads)
            self.mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
            self.routeSteps.removeAllObjects()
            self.distSteps.removeAllObjects()
            
            for step in route.steps {
                self.routeSteps.add(step.instructions)
                let d = step.distance
                self.distSteps.add(String(format: "%.0f", d) + " m")
                self.detailSteps.add(String(step.notice ?? "all clear"))
            }

            self.myTableView.reloadData()
           
        })
    }
    
 
    func showTour() {
        let stops = tourManager.decodeTourData(from: tourEntity!) ?? []
        self.tourStops = stops

        tourNameLabel.text = tourEntity?.name ?? "Unnamed Tour"
        title = tourEntity?.name ?? "Tour Details"

        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)

        for (index, stop) in stops.enumerated() {
            guard let currentCoord = stop.coordinate() else {
                continue
            }

            if index == 0 {
                let region = MKCoordinateRegion(
                    center: currentCoord,
                    latitudinalMeters: 550,
                    longitudinalMeters: 550
                )
                mapView.setRegion(region, animated: true)
            }

            let annotation = MKPointAnnotation()
            annotation.title = stop.name
            annotation.subtitle = "Stop \(index + 1)"
            annotation.coordinate = currentCoord
            mapView.addAnnotation(annotation)
        }
    }

    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 3.0
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else { return }

        if let cityName = view.annotation?.title {
            self.selectedCity = cityName
        }
        
        for (index, stop) in tourStops.enumerated() {
            if let stopName = stop.name, stopName == annotation.title {
                calculateDirectionsToStop(stopIndex: index)
                break
            }
        }
    }

    
    @IBAction func nextStopTapped(_ sender: UIButton) {
        let nextIndex = currentStopIndex + 1
        if nextIndex < tourStops.count {
            calculateDirectionsToStop(stopIndex: nextIndex)
        }
        else {
            let alert = UIAlertController(title: "Tour Completed", message: "You have reached the end of the tour!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routeSteps.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: "mapcell") as? MapTableCell ??
        MapTableCell(style: .default, reuseIdentifier: "mapcell")

        tableCell.instruction.text = routeSteps[indexPath.row] as? String
        tableCell.distance.text = distSteps[indexPath.row] as? String
        
        return tableCell
    }
}
