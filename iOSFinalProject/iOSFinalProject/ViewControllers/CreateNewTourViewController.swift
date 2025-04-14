//
//  CreateNewTourViewController.swift
//  iOSFinalProject
//
//  Created by Carlos Castro on 2025-04-13.
//


//
//  CreateNewTourViewController.swift
//  iOSFinalProject
//
//  Created by Carlos Castro on 2025-04-13.
//


import UIKit
import MapKit
import CoreLocation

class CreateNewTourViewController: UIViewController, MKMapViewDelegate, UISearchBarDelegate, UITableViewDataSource {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tourNameField: UITextField!
    @IBOutlet weak var tableView: UITableView!

    var newTourStops: [TourData] = []
    var tourManager = TourManager()
    var tourId = Int.random(in: 1000...9999)

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        searchBar.delegate = self
        tableView.dataSource = self

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleMapTap(_:)))
        mapView.addGestureRecognizer(tapGesture)

        // Zoom to Canoe Restaurant (Downtown Toronto)
        let center = CLLocationCoordinate2D(latitude: 43.6475, longitude: -79.3810)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: 2000, longitudinalMeters: 2000)
        mapView.setRegion(region, animated: true)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            newTourStops.remove(at: indexPath.row)

            // Refresh orderIndex for consistency (optional)
            for (i, stop) in newTourStops.enumerated() {
                stop.orderIndex = i
            }

            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }


    // MARK: - Map Tap Handler
    @objc func handleMapTap(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: mapView)
        let coordinate = mapView.convert(location, toCoordinateFrom: mapView)

        let alert = UIAlertController(title: "Add this location?", message: "Lat: \(coordinate.latitude), Lon: \(coordinate.longitude)", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Enter stop name"
        }
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { _ in
            let name = alert.textFields?.first?.text ?? "Unnamed Stop"
            self.addStop(name: name, coordinate: coordinate)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
    }

    // MARK: - Add Stop
    func addStop(name: String, coordinate: CLLocationCoordinate2D) {
        let stop = TourData()
        stop.id = Int.random(in: 1000...9999)
        stop.name = name
        stop.latitude = coordinate.latitude
        stop.longitude = coordinate.longitude
        stop.orderIndex = newTourStops.count
        stop.tourId = tourId
        stop.tourName = tourNameField.text ?? "New Tour"
        newTourStops.append(stop)

        // Drop pin
        let annotation = MKPointAnnotation()
        annotation.title = name
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)

        tableView.reloadData()
    }

    // MARK: - Search
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        guard let query = searchBar.text else { return }

        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = mapView.region

        let search = MKLocalSearch(request: request)
        search.start { response, error in
            guard let coordinate = response?.mapItems.first?.placemark.coordinate else {
                print("❌ No results found")
                return
            }

            let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 4000, longitudinalMeters: 4000)
            self.mapView.setRegion(region, animated: true)

            // No pin or stop added here. Just zooms to location.
            print("🔍 Moved to location: \(coordinate.latitude), \(coordinate.longitude)")
        }
    }



    // MARK: - Save Tour
    @IBAction func saveTourTapped(_ sender: UIBarButtonItem) {
        guard let name = tourNameField.text, !name.isEmpty else { return }
        tourManager.saveTour(name: name, stops: newTourStops)
        navigationController?.popViewController(animated: true)
    }

    // MARK: - TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newTourStops.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let stop = newTourStops[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewTourStopCell", for: indexPath) as! NewTourStopCell

        cell.stopTitleLabel.text = stop.name ?? "Unnamed Stop"
        if let lat = stop.latitude, let lon = stop.longitude {
            cell.coordinateLabel.text = String(format: "Lat: %.4f, Lon: %.4f", lat, lon)
        } else {
            cell.coordinateLabel.text = "Coordinates unavailable"
        }

        return cell
    }

}
