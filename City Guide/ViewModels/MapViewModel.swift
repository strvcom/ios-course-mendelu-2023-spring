//
//  MapItemsViewModel.swift
//  City Guide
//
//  Created by David Prochazka on 30.03.2023.
//

import Foundation
import SwiftUI
import CoreData
import CoreLocation

@MainActor
class MapItemsViewModel: ObservableObject {
    @Published var mapItems: [MapItem] = []
    @Published var selectedMapItem: MapItem?
    @Published var isLoadingIP: Bool = false
    
    var moc: NSManagedObjectContext
    private let apiManager: ApiManaging = APIManager()

    init(moc: NSManagedObjectContext){
        self.moc = moc
    }
    
    func selectMapItem(id: UUID) {
        selectedMapItem = mapItems.first(where: { $0.id == id })
    }
    
    func convertToMapItems(pois: FetchedResults<PointOfInterest>) {
        mapItems = pois.map{
            let image: UIImage
            if let storedImageData = $0.image{
                image = UIImage(data: storedImageData) ?? UIImage()
            } else {
                image = UIImage(named: "empty") ?? UIImage()
            }
            
            return MapItem(
                id: $0.id ?? UUID(),
                name: $0.name ?? "Unknown",
                style: MapItem.ArchitecturalStyle(rawValue: $0.style) ?? .None,
                image: image,
                coordinates: .init(latitude: $0.latitude, longitude: $0.longitude),
                locationType: MapItem.LocationType(rawValue: $0.locationType) ?? .None,
                email: $0.email ?? ""
            )
        }
    }
    
    func addMapItem(item: MapItem) {
        let newPoi = PointOfInterest(context: moc)
        newPoi.id = item.id
        newPoi.name = item.name
        newPoi.style = item.style.rawValue
        newPoi.latitude = item.coordinates.latitude
        newPoi.longitude = item.coordinates.longitude
        newPoi.id = item.id
        newPoi.email = item.email
        newPoi.image = item.image.pngData()
        newPoi.locationType = item.locationType.rawValue
        save()
        
        mapItems.append(item)
    }
    
    private func save(){
        if moc.hasChanges {
            do {
                try moc.save()
            } catch  {
                print(error)
            }
        }
    }
    
    func addInitialData() {
        let tugenthat = MapItem(
            id: UUID(),
            name: "Villa Tugenthat",
            style: .Modern,
            image: UIImage(named: "tugenthat") ?? UIImage(),
            coordinates: CLLocationCoordinate2D(latitude: 49.2072, longitude: 16.61599),
            locationType: .Public,
            email: "info@tugenthat.cz")
        
        let mendelu = MapItem(
            id: UUID(),
            name: "Mendel University in Brno",
            style: .Neoclassical,
            image: UIImage(named: "mendelu") ?? UIImage(),
            coordinates: CLLocationCoordinate2D(latitude: 49.2105, longitude: 16.6154),
            locationType: .House,
            email: "info@mendelu.cz")

        addMapItem(item: tugenthat)
        addMapItem(item: mendelu)
    }
    
    private func getPoi(with id: UUID) -> PointOfInterest? {
        let request = PointOfInterest.fetchRequest()
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        guard let items = try? moc.fetch(request) else { return nil }
        return items.first
    }
    
    func deleteMapItem(deletedPoiId: UUID) {
        if let deletedPoi = getPoi(with: deletedPoiId){
            moc.delete(deletedPoi)
            save()
        }
    }
    
    func addIPMapItem() async throws {
        isLoadingIP = true
        
        defer {
            isLoadingIP = false
        }
        
        var ipAddressURL = URL(string: "https://api.ipify.org")!
        ipAddressURL = ipAddressURL.appending(queryItems: [URLQueryItem(name: "format", value: "json")])
        let ipAddressRequest = URLRequest(url: ipAddressURL)
        let ipAddress: IPAddressDTO = try await apiManager.request(ipAddressRequest)
        
        print("RESPONSE: \(ipAddress)")
        
        var ipInfoURL = URL(string: "https://ipinfo.io")!
        ipInfoURL = ipInfoURL.appendingPathComponent(ipAddress.ip)
        ipInfoURL = ipInfoURL.appendingPathComponent("geo")
        let ipInfoURLRequest = URLRequest(url: ipInfoURL)
        let ipInfo: IPInfoDTO = try await apiManager.request(ipInfoURLRequest)
        
        print("RESPONSE: \(ipInfo)")
        
        
        let mapItem = convertInfoToMapItem(response: ipInfo)
        mapItems.append(mapItem)
    }
    
    func convertInfoToMapItem(response: IPInfoDTO) -> MapItem {
        let coordinates = response.loc.split(separator: ",")
        let latitude = Double(coordinates.first ?? "") ?? 0
        let longitude = Double(coordinates.last ?? "") ?? 0
        
        return MapItem(
            id: UUID(),
            name: "IP \(response.region)",
            style: .None,
            image: UIImage(),
            coordinates: CLLocationCoordinate2D(
                latitude: latitude,
                longitude: longitude
            ),
            locationType: .None
        )
    }
}
