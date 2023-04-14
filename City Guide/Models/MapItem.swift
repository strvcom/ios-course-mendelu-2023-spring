//
//  MapItem.swift
//  City Guide
//
//  Created by David Procházka on 22.03.2023.
//

import SwiftUI
import MapKit

struct MapItem: Identifiable {
    let id: UUID
    var name: String
    var style: ArchitecturalStyle
    var image: UIImage
    var coordinates: CLLocationCoordinate2D
    var locationType: LocationType
    var email: String = ""
    
    enum LocationType: Int16, CaseIterable, Identifiable {
        var id: Self { self }

        case None = 0
        case House = 1
        case Public = 2
        case Industrial = 3
        
        var symbol: Text{
            switch self {
            case .None:
                return Text("👎")
            case .House:
                return Text("🏠")
            case .Industrial:
                return Text("🏭")
            case .Public:
                return Text("🏫")
            }
        }
        
        var name: String{
            get { return String(describing: self) }
        }
    }
    
    enum ArchitecturalStyle: Int16, CaseIterable, Identifiable {
        var id: Self { self }

        case None = 0
        case Modern = 1
        case Secession = 2
        case Neoclassical = 3
        case Baroque = 4
        case Gothic = 5
        
        var name: String{
            get { return String(describing: self) }
        }
    }
}

// MARK: - Mocks
extension MapItem {
    // Dummy item shows point "Za luzankami" stadium
    static let mock = MapItem(
        id: UUID(),
        name: "IP",
        style: .None,
        image: UIImage(named: "empty") ?? UIImage(),
        coordinates: CLLocationCoordinate2D(latitude: 49.2125, longitude: 16.6124),
        locationType: .None
    )
}
