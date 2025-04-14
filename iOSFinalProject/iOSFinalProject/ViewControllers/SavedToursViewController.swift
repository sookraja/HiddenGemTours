//
//  SavedToursViewController.swift
//  iOSFinalProject
//
//  Created by Carlos Castro on 2025-04-12.
//


import UIKit

class SavedToursViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

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
            addTours()
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        savedTours = tourManager.loadTours()
        tableView.reloadData()
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let tourToDelete = savedTours[indexPath.row]
            tourManager.deleteTour(tourToDelete)

            savedTours.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    @IBAction func unwindToSavedTours(segue: UIStoryboardSegue) {
        print("🔙 Unwound from TourDetailViewController")
    }

    // MARK: - TableView Data Source & Delegate

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

    // MARK: - Sample Tour Data

    func addTours() {
        // Downtown Toronto Tour
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

        // Museum Tour
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

        // Bolton Heritage Walk Tour
        let stop1 = TourData()
        stop1.id = 201
        stop1.name = "Bolton Farmers' Market"
        stop1.latitude = 43.875281
        stop1.longitude = -79.737930
        stop1.tourId = 201
        stop1.tourName = "Bolton Heritage Walk"
        stop1.orderIndex = 0

        let stop2 = TourData()
        stop2.id = 202
        stop2.name = "Downtown Bolton Murals"
        stop2.latitude = 43.876520
        stop2.longitude = -79.738840
        stop2.tourId = 201
        stop2.tourName = "Bolton Heritage Walk"
        stop2.orderIndex = 1

        let stop3 = TourData()
        stop3.id = 203
        stop3.name = "Humber River Trail Entrance"
        stop3.latitude = 43.876950
        stop3.longitude = -79.740910
        stop3.tourId = 201
        stop3.tourName = "Bolton Heritage Walk"
        stop3.orderIndex = 2

        let stop4 = TourData()
        stop4.id = 204
        stop4.name = "Bolton Mill Ruins"
        stop4.latitude = 43.875910
        stop4.longitude = -79.742200
        stop4.tourId = 201
        stop4.tourName = "Bolton Heritage Walk"
        stop4.orderIndex = 3

        let stop5 = TourData()
        stop5.id = 205
        stop5.name = "Founders' Park"
        stop5.latitude = 43.874600
        stop5.longitude = -79.740700
        stop5.tourId = 201
        stop5.tourName = "Bolton Heritage Walk"
        stop5.orderIndex = 4

        // Save all 3 tours
        tourManager.saveTour(name: "Downtown Toronto", stops: [tour1Stop1, tour1Stop2, tour1Stop3, tour1Stop4, tour1Stop5])
        tourManager.saveTour(name: "Museum Tour", stops: [tour2Stop1, tour2Stop2, tour2Stop3, tour2Stop4, tour2Stop5])
        tourManager.saveTour(name: "Bolton Heritage Walk", stops: [stop1, stop2, stop3, stop4, stop5])

        print("✅ All tours with 5 stops each saved")
    }
}
