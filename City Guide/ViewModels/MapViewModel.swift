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
    
    var moc: NSManagedObjectContext
    private let apiManager: APIManaging = APIManager()

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
}

// MARK: - Networking seminar

/*
 
 FLOW:
 a) show added button in app, mock static data for MapItem
 b) write down direct url request with async await (constants)
 c) improve with api manager (protocol + implementation), explain reasons we have it
 d) wrap in Task
 
 BONUS:
 a) describe multiple model objects (DTO, BDO) and conversion between them
 b) Router protocol - scalability structure, build URLRequest from request parameters(headers, body etc)
 */

extension MapItemsViewModel {
    func addIPMapItem() async throws {
        // call first request
        let ipDTO = try await getIP()
        // call second request with response from first request
        let ipInfo = try await getIPInfo(ipAddress: ipDTO.ip)
        // create MapItem
        let mapItem = try MapItem(ipInfo: ipInfo)
        // append to array
        mapItems.append(mapItem)
    }
    
    private func getIP() async throws -> IPDTO {
        try await apiManager.request(IPRouter.getIP)
    }
    
    private func getIPInfo(ipAddress: String) async throws -> IPInfoDTO {
        try await apiManager.request(IPRouter.getIPInfo(ipAddress: ipAddress))
    }
}
