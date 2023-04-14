//
//  ContentView.swift
//  City Guide
//
//  Created by David Procházka on 22.03.2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @StateObject var mapItemsViewModel: MapItemsViewModel
    
    var body: some View {
        MapView(mapItemsViewModel: mapItemsViewModel)
        
        /*
        VStack{
            List(mapItemsViewModel.mapItems){ mapItem in
                Text(mapItem.name)
            }.onAppear(){
                mapItemsViewModel.convertToMapItems(pois: pois)
            }
            
            Button("Add") {
                let mapItem = MapItem(
                    name: "xxx",
                    style: .Modern,
                    imageAssetName: "",
                    coordinates: .init(latitude: 49.1, longitude: 16.7),
                    locationType: .Industrial)
                mapItemsViewModel.addMapItem(item: mapItem, moc: moc)
                mapItemsViewModel.convertToMapItems(pois: pois)
            }
        }
         */
    }
}

/*
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(mapItemsViewModel: MapItemsViewModel())
    }
}
*/
