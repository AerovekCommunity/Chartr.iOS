/*
The MIT License (MIT)

Copyright (c) 2023-present Aerovek

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

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
