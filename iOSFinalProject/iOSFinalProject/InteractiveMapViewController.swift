//
//  InteractiveMapViewController.swift
//  iOSFinalProject
//
//  Created by Edgar Ponce on 2025-04-09.
//

import UIKit
import MapKit
import CoreLocation

class InteractiveMapViewController: UIViewController, UITextFieldDelegate,MKMapViewDelegate {
    
    let locationManager = CLLocationManager()
    let userCurrentlocation = CLLocationCoordinate2D()
    let regionRadius: CLLocationDistance = 550
    
    @IBOutlet var myMapView : MKMapView!
    @IBOutlet var tbLocationEntered: UITextField!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return false;
    }
    
    func centerMapOnLocation(location: CLLocation)
    {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        myMapView.setRegion(coordinateRegion, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        myMapView.showsUserLocation = true
        locationManager.startUpdatingLocation()
        
        //this is a timer that is in place to check the users location every second
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self else { return }
            
            if let userLocation = self.myMapView.userLocation.location {
                self.centerMapOnLocation(location: userLocation)
                timer.invalidate()
                self.locationManager.stopUpdatingLocation() // Stop updates to save battery
            }
        }
    }
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
