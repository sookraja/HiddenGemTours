//
//  WeatherViewController.swift
//  iOSFinalProject
//  Desc: Sends API request using the users current location, and decodes the JSON data to display it, also displays a mapview of their location
//  Created by Annette Sookraj on 2025-03-28.
//

import UIKit
import CoreLocation
import MapKit

class WeatherViewController: UIViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var weatherLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupMapView()
        configureLocationManager()
    }

    func setupMapView() {
        weatherLabel.layer.cornerRadius = 10
        mapView.frame = view.bounds
        mapView.showsUserLocation = true
        view.addSubview(mapView)
    }

    func configureLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }

        let region = MKCoordinateRegion(center: location.coordinate,
                                        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        mapView.setRegion(region, animated: true)

        fetchWeather(lat: location.coordinate.latitude, long: location.coordinate.longitude)
        locationManager.stopUpdatingLocation()
    }

    func fetchWeather(lat: Double, long: Double) {
        let apiKey = "35d5aa775f94458ebb2221915250504"
        let urlString = "https://api.weatherapi.com/v1/current.json?key=\(apiKey)&q=\(lat),\(long)"

        guard let url = URL(string: urlString) else { return }

        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }

            do {
                let weatherData = try JSONDecoder().decode(WeatherAPIResponse.self, from: data)
                DispatchQueue.main.async {
                    self.weatherLabel.text = "\(weatherData.current.temp_c)°C - \(weatherData.current.condition.text)"
                }
            } catch {
                print("Failed to decode WeatherAPI data: \(error)")
            }
        }
        task.resume()
    }
}
