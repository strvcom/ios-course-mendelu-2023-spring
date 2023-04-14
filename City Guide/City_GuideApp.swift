//
//  City_GuideApp.swift
//  City Guide
//
//  Created by David Procházka on 22.03.2023.
//

import SwiftUI

@main
struct City_GuideApp: App {
    @StateObject private var dataController = CoreDataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView(mapItemsViewModel: MapItemsViewModel(moc: dataController.container.viewContext))
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
