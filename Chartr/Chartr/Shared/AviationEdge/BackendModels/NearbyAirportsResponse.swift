//
//  NearbyAirportsResponse.swift
//  Chartr
//
//  Created by Jay Martinez on 6/22/22.
//

struct NearbyAirportsResponse: Decodable {
    let gmt: String
    let codeIataAirport: String
    let codeIataCity: String
    let codeIcaoAirport: String
    let countryCode: String
    let distance: Double
    let lat: Double
    let lng: Double
    let name: String
    let country: String
    let phone: String
    let timezone: String
    
    enum CodingKeys: String, CodingKey {
        case gmt = "GMT"
        case codeIataAirport
        case codeIataCity
        case codeIcaoAirport
        case countryCode = "codeIso2Country"
        case distance
        case lat = "latitudeAirport"
        case lng = "longitudeAirport"
        case name = "nameAirport"
        case country = "nameCountry"
        case phone
        case timezone
    }
}
