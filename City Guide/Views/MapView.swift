//
//  MapView.swift
//  City Guide
//
//  Created by David Procházka on 22.03.2023.
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject var locManager = LocationManager()
    @State private var detailPresented: Bool = false
    @State private var newPointViewPresented: Bool = false

    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: []) var pois: FetchedResults<PointOfInterest>
    @StateObject var mapItemsViewModel: MapItemsViewModel

    func refreshPoints() {
        mapItemsViewModel.convertToMapItems(pois: pois)
    }
    
    var body: some View {
        NavigationView{
            Map(coordinateRegion: $locManager.region, interactionModes: .all, showsUserLocation: true, userTrackingMode: .constant(.follow), annotationItems: mapItemsViewModel.mapItems){ item in
                
                MapAnnotation(coordinate: item.coordinates) {
                    ZStack(alignment: .center) {
                        ZStack{
                            VStack{
                                
                                Text("\(item.name)")
                                    .fontWeight(.semibold)
                                Text("\(item.style.name)")
                                    .fontWeight(.light)
                            }
                            .padding(.all, 5.0)
                            .background(Gradient(colors: [.indigo, .indigo]))
                            .foregroundColor(.white)
                            .cornerRadius(5)
                        }
                        .offset(y: 45)
                        
                        Circle()
                            .fill(Gradient(colors: [.indigo, .indigo]))
                            .frame(width: 35, height: 35)
                        
                        item.locationType.symbol
                    }
                    
                    .scaleEffect(0.8, anchor: .center)
                    .onTapGesture {
                        mapItemsViewModel.selectMapItem(id: item.id)
                        detailPresented.toggle()
                    }
                }
                
            }
            .onAppear(){
                if mapItemsViewModel.mapItems.count == 0 {
                    mapItemsViewModel.addInitialData()                    
                }
                refreshPoints()
            }
            .sheet(isPresented: $detailPresented){
                DetailView(detailPresented: $detailPresented, modelView: mapItemsViewModel, locationManager: locManager, mapView: self)
                    .presentationDetents([.fraction(0.25), .large]) // umožní částeční vyjetí sheetu
            }
            .sheet(isPresented: $newPointViewPresented){
                NewMapItemView(
                    newPointPresented: $newPointViewPresented,
                    mapViewModel: mapItemsViewModel,
                    locationCoordinates: locManager.location ?? .init())
            }
            
            .edgesIgnoringSafeArea(.bottom)
            .navigationTitle("City Guide")
            .toolbar{
                ToolbarItemGroup(placement: .navigationBarTrailing){
                    Button("Add Point"){
                        newPointViewPresented.toggle()
                    }
                }
            }
        }
    }
}

/*
struct MapView_Previews: PreviewProvider {
    
    static var previews: some View {
        MapView(mapItemsViewModel: MapItemsViewModel(moc: moc))
    }
}
*/
