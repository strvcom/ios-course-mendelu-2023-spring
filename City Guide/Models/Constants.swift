//
//  Constants.swift
//  City Guide
//
//  Created by Tomas Cejka on 14.04.2023.
//

import Foundation

enum Host {
    // careful force unwraps
    static let ipify = URL(string: "https://api.ipify.org?format=json")!
    
    static func ipinfo(ip: String) {
        var url = URL(string: "https://ipinfo.io")!
        url = url.appendingPathComponent(ip)
        url = url.appendingPathComponent("geo")
    }
}
