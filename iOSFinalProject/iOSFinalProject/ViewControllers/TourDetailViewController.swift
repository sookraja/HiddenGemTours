//
//  TourDetailViewController.swift
//  iOSFinalProject
//
//  Created by Carlos Castro on 2025-04-12.
//

import UIKit
import MapKit

class TourDetailViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tourNameLabel: UILabel!
    @IBOutlet weak var stopsTextView: UITextView!
    @IBOutlet weak var beginTourButton: UIButton!

    var tourEntity: TourEntity?
    let tourManager = TourManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        showTour()
    }

    func showTour() {
        guard let tourEntity = tourEntity else {
            print("❌ No tourEntity received")
            return
        }

        guard let stops = tourManager.decodeTourData(from: tourEntity) else {
            print("❌ Failed to decode TourData from TourEntity")
            return
        }

        print("✅ Decoded \(stops.count) stops")

        tourNameLabel.text = tourEntity.name ?? "Unnamed Tour"
        title = tourEntity.name ?? "Tour Details"

        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)

        var stopText = ""
        var firstCoord: CLLocationCoordinate2D?

        for (index, stop) in stops.enumerated() {
            guard let currentCoord = stop.coordinate() else {
                print("⚠️ Stop \(index + 1) has no valid coordinates")
                continue
            }

            if index == 0 { firstCoord = currentCoord }

            let annotation = MKPointAnnotation()
            annotation.title = stop.name
            annotation.subtitle = "Stop \(index + 1)"
            annotation.coordinate = currentCoord
            mapView.addAnnotation(annotation)

            // Draw walking route to next stop
            if index < stops.count - 1, let nextCoord = stops[index + 1].coordinate() {
                drawCompleteTourRoute(stops)
            }

            stopText += "• \(stop.name ?? "Unnamed Stop")\n"
        }

        // ✅ Update the TextView
        stopsTextView.text = stopText
        stopsTextView.isEditable = false

        // ✅ Zoom to first stop after a small delay
        if let first = firstCoord {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                let region = MKCoordinateRegion(center: first,
                                                latitudinalMeters: 2000,
                                                longitudinalMeters: 2000)
                self.mapView.setRegion(region, animated: true)
            }
        } else {
            print("⚠️ No valid first coordinate found for zoom")
        }
    }

    func drawCompleteTourRoute(_ stops: [TourData]) {
        guard stops.count > 1 else { return }

        for i in 0..<stops.count - 1 {
            guard let from = stops[i].coordinate(),
                  let to = stops[i + 1].coordinate() else { continue }

            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: from))
            request.destination = MKMapItem(placemark: MKPlacemark(coordinate: to))
            request.transportType = .walking

            let directions = MKDirections(request: request)
            directions.calculate { response, error in
                if let route = response?.routes.first {
                    self.mapView.addOverlay(route.polyline)
                } else {
                    print("❌ Route segment \(i) failed: \(error?.localizedDescription ?? "Unknown error")")
                }
            }
        }
    }


    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let polyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .systemBlue
            renderer.lineWidth = 4
            return renderer
        }
        return MKOverlayRenderer(overlay: overlay)
    }

    @IBAction func beginTourTapped(_ sender: UIButton) {
        guard let stops = tourManager.decodeTourData(from: tourEntity!) else { return }

        for (index, stop) in stops.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 2.0) {
                if let coord = stop.coordinate() {
                    let region = MKCoordinateRegion(center: coord,
                                                    latitudinalMeters: 1500,
                                                    longitudinalMeters: 1500)
                    self.mapView.setRegion(region, animated: true)
                }
            }
        }
    }
}
