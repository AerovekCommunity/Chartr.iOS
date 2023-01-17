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

import Hyperspace
import BrightFutures

class AviationEdgeService {
    private let baseUrl: URL
    private let backendService: BackendService
    private let apiKey = "958006-791817"
    
    init() {
        self.baseUrl = URL(string: "http://aviation-edge.com/v2/public")!
        self.backendService = BackendService()
    }
    
    /// Retrieves airports [distance] miles from the passed in lat and long
    func getNearbyAirports(lat: Double, long: Double, distance: Int) -> Future<[NearbyAirportsResponse], AnyError>  {
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "lat", value: String(lat)),
            URLQueryItem(name: "lng", value: String(long)),
            URLQueryItem(name: "distance", value: String(distance))
        ]
        
        
        let url = self.baseUrl
            .appendingPathComponent("nearby")
            .appendingQueryItems(queryItems)
        
        let request: Request<[NearbyAirportsResponse], AnyError> = Request(method: .get, url: url)
        return self.getResponse(request)
    }
    
    // MARK: Private
    private func getResponse<T>(_ request: Request<T, AnyError>) -> Future<T, AnyError> {
        return self.backendService.execute(request: request)
            .map { (result: T) in
                return result
            }
            .mapError {
                return $0
            }
    }
}
