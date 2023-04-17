//
//  IPInfoDTO.swift
//  City Guide
//
//  Created by Róbert Oravec on 17.04.2023.
//

struct IPInfoDTO: Decodable {
    let ip: String
    let city: String
    let region: String
    let country: String
    let loc: String
    let org: String
    let postal: String
    let timezone: String
    let readme: String
}

// "ip": "161.185.160.93",
// "city": "New York City",
// "region": "New York",
// "country": "US",
// "loc": "40.7143,-74.0060",
// "org": "AS22252 The City of New York",
// "postal": "10004",
// "timezone": "America/New_York",
// "readme": "https://ipinfo.io/missingauth"
