//
//  New Point.swift
//  City Guide
//
//  Created by David Prochazka on 05.04.2023.
//

import SwiftUI
import CoreLocation

struct NewMapItemView: View {
    @Binding var newPointPresented: Bool
    @StateObject var mapViewModel: MapItemsViewModel

    @State var locationCoordinates: CLLocationCoordinate2D
    @State var locationName: String = ""
    @State var locationStyle: MapItem.ArchitecturalStyle = .Modern
    @State var locationImage: UIImage = UIImage(named: "empty") ?? UIImage()
    @State var locationType: MapItem.LocationType = .House
    @State var locationEmail: String = ""

    @State var isPhotoLibPresented = false
    
    
    var body: some View {
        NavigationView{
            
            Form{
                Section(content: {
                    TextField("Insert location name", text: $locationName)
                    TextField("Insert location email (optional)", text: $locationEmail)

                }, header: {
                    Text("Name and email")
                }, footer: {
                    HStack{
                        Text("Latitude: \(locationCoordinates.latitude)")
                        Spacer()
                        Text("Longitude: \(locationCoordinates.longitude)")
                    }
                })
                
                
                Section("Details") {
                    
                    Picker("Architectural style", selection: $locationStyle) {
                        ForEach(MapItem.ArchitecturalStyle.allCases) { option in
                            Text(option.name)
                        }
                    }
                    .pickerStyle(.automatic)
                    
                    Picker("Location type", selection: $locationType) {
                        ForEach(MapItem.LocationType.allCases) { option in
                            Text(option.name)
                        }
                    }
                    .pickerStyle(.automatic)
                    
                }
                
                Section("Image") {
                    Image(uiImage: locationImage)
                        .resizable()
                        .scaledToFit()
                    
                    Button(action: {
                        self.isPhotoLibPresented = true
                    }){
                        Text("Choose Image")
                    }
                    .sheet(isPresented: $isPhotoLibPresented){
                        ImagePicker(selectedImage: $locationImage, isPickerPresented: $isPhotoLibPresented, sourceType: .photoLibrary)
                    }
                    .buttonStyle(.bordered)
                }
            }
            .navigationTitle("New Location")
            .toolbar{
                ToolbarItemGroup(placement: .navigationBarLeading){
                    Button("Close"){
                        newPointPresented.toggle()
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing){
                    Button("Save"){
                        addMapPoint()
                        newPointPresented.toggle()
                    }
                }
            }
        }
    }
    
    func addMapPoint() {
        let newItem = MapItem(
            id: UUID(),
            name: locationName,
            style: locationStyle,
            image: locationImage,
            coordinates: locationCoordinates,
            locationType: locationType,
            email: locationEmail)
        
        mapViewModel.addMapItem(item: newItem)
    }
}

/*
struct NewMapItem_Previews: PreviewProvider {
    static var previews: some View {
        NewMapItem(newPointPresented: .constant(true), mapViewModel: MapItemsViewModel(), locationCoordinates: .init(latitude: 49.2, longitude: 13.54))
    }
}
*/
