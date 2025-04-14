//
//  TourManager.swift
//  iOSFinalProject
//
//  Created by Carlos Castro on 2025-04-12.
//


import Foundation
import UIKit
import CoreData

class TourManager {

    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    func deleteTour(_ tour: TourEntity) {
        context.delete(tour)
        do {
            try context.save()
            print("🗑️ Tour deleted")
        } catch {
            print("❌ Failed to delete tour: \(error)")
        }
    }

    // Save a tour using [TourData]
    func saveTour(name: String, stops: [TourData]) {
        let tour = TourEntity(context: context)
        tour.name = name
        tour.locations = try? JSONEncoder().encode(stops)

        do {
            try context.save()
            print("Tour '\(name)' saved successfully.")
        } catch {
            print("Failed to save tour: \(error)")
        }
    }

    // Load all tours
    func loadTours() -> [TourEntity] {
        let request: NSFetchRequest<TourEntity> = TourEntity.fetchRequest()
        do {
            return try context.fetch(request)
        } catch {
            print("Failed to load tours: \(error)")
            return []
        }
    }

    // Decode the [TourData] from a saved TourEntity
    func decodeTourData(from entity: TourEntity) -> [TourData]? {
        guard let data = entity.locations else { return nil }
        return try? JSONDecoder().decode([TourData].self, from: data)
    }
}
