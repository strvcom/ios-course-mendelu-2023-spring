//
//  DataController.swift
//  City Guide
//
//  Created by David Prochazka on 30.03.2023.
//

import Foundation
import CoreData

class CoreDataController: ObservableObject {
    let container = NSPersistentContainer(name: "CityGuide")

    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}

