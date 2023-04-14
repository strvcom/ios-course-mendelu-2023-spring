//
//  LocationManager.swift
//  City Guide
//
//  Created by David Prochazka on 29.03.2023.
//

import Foundation
import CoreLocation
import MapKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()

    @Published var location: CLLocationCoordinate2D?
    @Published var locationDescription: CLPlacemark?
    @Published var region: MKCoordinateRegion = .init()

    override init() {
        super.init()
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func getCurrentLocationDescription(){
        let geocoder = CLGeocoder()
        if let actLocation = location{
            let loc = CLLocation(latitude: actLocation.latitude, longitude: actLocation.longitude)
            
            geocoder.reverseGeocodeLocation(loc, completionHandler: {
                (placemarks, error) in
                if error != nil {
                    print("Reverse Geocode failed: \(String(describing: error)))")
                } else if let firstPlacemark = placemarks?.first {
                    self.locationDescription = firstPlacemark
                }else{
                    print("No placemark found")
                }
            })
        }
    }
    
    func getCurrentDistanceFrom(coords: CLLocationCoordinate2D) -> Double?{
        let fromLocation: CLLocation = .init(latitude: coords.latitude, longitude: coords.longitude)
        
        if let currentLocationCorrds = location{
            let currentLocation: CLLocation = .init(latitude: currentLocationCorrds.latitude,
                                                    longitude: currentLocationCorrds.longitude)
            return fromLocation.distance(from: currentLocation)
        }
        return nil
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let actLocation = locations.first {
            location = actLocation.coordinate
            
            region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: actLocation.coordinate.latitude,
                                               longitude: actLocation.coordinate.longitude),
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            getCurrentLocationDescription()
        }
    }
}
