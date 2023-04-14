//
//  DetailView.swift
//  City Guide
//
//  Created by David Procházka on 22.03.2023.
//

import SwiftUI

struct DetailView: View {
    @Binding var detailPresented: Bool
    var modelView: MapItemsViewModel
    var locationManager: LocationManager
    var mapView: MapView
    
    private func openMapApp(mapItem: MapItem) {
        let url = URL(string: "maps://?saddr=&daddr=\(mapItem.coordinates.latitude),\(mapItem.coordinates.longitude)")
        if UIApplication.shared.canOpenURL(url!) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        }
    }
    
    private func openEmail(mapItem: MapItem){
        let url = URL(string: "mailto:\(mapItem.email)")
        if UIApplication.shared.canOpenURL(url!) {
            UIApplication.shared.open(url!, options: [:], completionHandler: nil)
        }
    }
    
    var body: some View {
        NavigationView{
            if let mapItem = modelView.selectedMapItem {
                
                ScrollView{
                    VStack{
                        let distance: Double? = locationManager.getCurrentDistanceFrom(coords: mapItem.coordinates)
                        
                        Text("Distance: \(Int(distance ?? 0)) m")
                        
                        HStack{
                            if (mapItem.email != ""){
                                Button(action: {
                                    openEmail(mapItem: mapItem)
                                }, label: {
                                    Label("Message", systemImage: "envelope")
                                }).buttonStyle(CapsuleBlueButton())
                            }
                            
                            Button(action: {
                                openMapApp(mapItem: mapItem)
                            }, label: {
                                Label("Navigate", systemImage: "map")
                            }).buttonStyle(CapsuleBlueButton())
                        }
                        
                        Image(uiImage: mapItem.image)
                            .resizable()
                            .scaledToFit()
                            .clipShape(Circle())
                            .padding(.all)
                    }
                }
                .navigationTitle("\(mapItem.name)")
                .toolbar{
                    ToolbarItemGroup(placement: .navigationBarLeading){
                        Button("Close"){
                            detailPresented.toggle()
                        }
                    }
                    
                    ToolbarItemGroup(placement: .navigationBarTrailing){
                        Button("Delete"){
                            if let selectedMapItem = modelView.selectedMapItem{
                                modelView.deleteMapItem(deletedPoiId: selectedMapItem.id)
                                mapView.refreshPoints()
                                detailPresented.toggle()
                            }
                        }
                    }
                }
            } else {
                ErrorView()
                .navigationTitle("Ooops...")
                .toolbar{
                    ToolbarItemGroup(placement: .navigationBarLeading){
                        Button("Close"){
                            detailPresented.toggle()
                        }
                    }
                }
            }
        }
    }
}
/*

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        
        
        //DetailView(detailPresented: .constant(true), modelView: MapItemsViewModel(moc: ), locationManager: LocationManager())
    }
}

*/
