//
//  LocationService.swift
//  Chartr
//
//  Created by Jay Martinez on 6/21/22.
//

import Foundation
import CoreLocation
import Hyperspace
import BrightFutures

class LocationService: NSObject {
    
    private var locationCallback: ((Result<CLLocation?, AnyError>) -> Void)?
    private let locationManager = CLLocationManager()
    private var locationFuture: Future<CLLocation?, AnyError>?

    func requestLocation() -> Future<CLLocation?, AnyError> {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.requestLocation()
        locationFuture = Future<CLLocation?, AnyError> { self.locationCallback = $0 }
        return locationFuture!
    }
}

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last, !(locationFuture?.isCompleted ?? true) {
            locationCallback?(.success(location))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if !(locationFuture?.isCompleted ?? true) {
            locationCallback?(.failure(AnyError(error)))
        }
    }
}
