//
//  SavedToursViewController.swift
//  iOSFinalProject
//
//  Created by Carlos Castro on 2025-04-12.
//


import UIKit

class SavedToursViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let tourManager = TourManager()
    var savedTours: [TourEntity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Saved Tours"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        savedTours = tourManager.loadTours()
        
        if savedTours.isEmpty {
            addSampleTours()
            savedTours = tourManager.loadTours()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showTourDetail",
           let indexPath = tableView.indexPathForSelectedRow,
           let destination = segue.destination as? TourDetailViewController {
            let selectedTour = savedTours[indexPath.row]
            destination.tourEntity = selectedTour
        }
    }
    
    func addSampleTours() {
        // 🏙️ Downtown Toronto Tour
        let tour1Stop1 = TourData()
        tour1Stop1.id = 1
        tour1Stop1.name = "CN Tower"
        tour1Stop1.latitude = 43.6426
        tour1Stop1.longitude = -79.3871
        tour1Stop1.tourId = 101
        tour1Stop1.tourName = "Downtown Toronto"
        tour1Stop1.orderIndex = 0
        
        let tour1Stop2 = TourData()
        tour1Stop2.id = 2
        tour1Stop2.name = "Ripley's Aquarium"
        tour1Stop2.latitude = 43.6424
        tour1Stop2.longitude = -79.3860
        tour1Stop2.tourId = 101
        tour1Stop2.tourName = "Downtown Toronto"
        tour1Stop2.orderIndex = 1
        
        let tour1Stop3 = TourData()
        tour1Stop3.id = 3
        tour1Stop3.name = "Rogers Centre"
        tour1Stop3.latitude = 43.6414
        tour1Stop3.longitude = -79.3894
        tour1Stop3.tourId = 101
        tour1Stop3.tourName = "Downtown Toronto"
        tour1Stop3.orderIndex = 2
        
        let tour1Stop4 = TourData()
        tour1Stop4.id = 4
        tour1Stop4.name = "Roundhouse Park"
        tour1Stop4.latitude = 43.6404
        tour1Stop4.longitude = -79.3869
        tour1Stop4.tourId = 101
        tour1Stop4.tourName = "Downtown Toronto"
        tour1Stop4.orderIndex = 3
        
        let tour1Stop5 = TourData()
        tour1Stop5.id = 5
        tour1Stop5.name = "Steam Whistle Brewery"
        tour1Stop5.latitude = 43.6406
        tour1Stop5.longitude = -79.3863
        tour1Stop5.tourId = 101
        tour1Stop5.tourName = "Downtown Toronto"
        tour1Stop5.orderIndex = 4
        
        // 🖼️ Museum Tour
        let tour2Stop1 = TourData()
        tour2Stop1.id = 6
        tour2Stop1.name = "Royal Ontario Museum"
        tour2Stop1.latitude = 43.6677
        tour2Stop1.longitude = -79.3948
        tour2Stop1.tourId = 102
        tour2Stop1.tourName = "Museum Tour"
        tour2Stop1.orderIndex = 0
        
        let tour2Stop2 = TourData()
        tour2Stop2.id = 7
        tour2Stop2.name = "Bata Shoe Museum"
        tour2Stop2.latitude = 43.6670
        tour2Stop2.longitude = -79.4007
        tour2Stop2.tourId = 102
        tour2Stop2.tourName = "Museum Tour"
        tour2Stop2.orderIndex = 1
        
        let tour2Stop3 = TourData()
        tour2Stop3.id = 8
        tour2Stop3.name = "Gardiner Museum"
        tour2Stop3.latitude = 43.6675
        tour2Stop3.longitude = -79.3931
        tour2Stop3.tourId = 102
        tour2Stop3.tourName = "Museum Tour"
        tour2Stop3.orderIndex = 2
        
        let tour2Stop4 = TourData()
        tour2Stop4.id = 9
        tour2Stop4.name = "Queen's Park"
        tour2Stop4.latitude = 43.6629
        tour2Stop4.longitude = -79.3957
        tour2Stop4.tourId = 102
        tour2Stop4.tourName = "Museum Tour"
        tour2Stop4.orderIndex = 3
        
        let tour2Stop5 = TourData()
        tour2Stop5.id = 10
        tour2Stop5.name = "University of Toronto - Hart House"
        tour2Stop5.latitude = 43.6644
        tour2Stop5.longitude = -79.3933
        tour2Stop5.tourId = 102
        tour2Stop5.tourName = "Museum Tour"
        tour2Stop5.orderIndex = 4
        
        // Save both tours
        tourManager.saveTour(name: "Downtown Toronto", stops: [tour1Stop1, tour1Stop2, tour1Stop3, tour1Stop4, tour1Stop5])
        tourManager.saveTour(name: "Museum Tour", stops: [tour2Stop1, tour2Stop2, tour2Stop3, tour2Stop4, tour2Stop5])
        
        print("✅ Sample tours with 5 stops each saved")
    }
}

extension SavedToursViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedTours.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tour = savedTours[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TourCell", for: indexPath) as! TourCell

        cell.titleLabel.text = tour.name ?? "Unnamed Tour"

        if let tourData = tourManager.decodeTourData(from: tour) {
            cell.detailLabel.text = "\(tourData.count) stops"
        } else {
            cell.detailLabel.text = "No stops available"
        }

        return cell
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showTourDetail", sender: self)
    }
}
