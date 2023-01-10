//
//  AviationEdgeService.swift
//  Chartr
//
//  Created by Jay Martinez on 6/22/22.
//

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
