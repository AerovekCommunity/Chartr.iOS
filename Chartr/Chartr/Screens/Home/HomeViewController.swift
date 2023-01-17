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

import UIKit
import MapKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var tab1: UITabBarItem!
    @IBOutlet weak var tab2: UITabBarItem!
    @IBOutlet weak var tab3: UITabBarItem!
    @IBOutlet weak var tab4: UITabBarItem!
    
    private var userLocation: CLLocation?
    private var authorizationStatus: CLAuthorizationStatus = .notDetermined
    private lazy var locationManager = CLLocationManager()
    private lazy var aviationEdgeService = AviationEdgeService()
    
    // Default to LAX if user does not grant location permissions
    private var defaultLocation: CLLocation = CLLocation(latitude: 33.94286167403988, longitude: -118.41012859845847)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let chartrNavController = self.navigationController as? ChartrNavigationController else { return }
        chartrNavController.updateNavigationBar()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: "LocationPin")
        
        tabBar.delegate = self
        
        // zoom the map in to the default location so we don't show the entire world map
        setupMap(defaultLocation)
        
        //self.view.backgroundColor = .black
        //activityIndicator.color = .white
        //activityIndicator.startAnimating()
        //self.view.showActivityIndicator(style: .large)
        setupLocation()
    }
    
    /// Checks if the user has granted location permissions. If so we request location,
    /// if not we ask for permission then request location
    private func setupLocation() {
        locationManager.delegate = self
        authorizationStatus = locationManager.authorizationStatus
        
        switch authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        case .denied, .notDetermined, .restricted:
            locationManager.requestWhenInUseAuthorization()
        default:
            break
        }
    }
    
    private func getNearbyAirports(_ location: CLLocation) {
        aviationEdgeService.getNearbyAirports(lat: location.coordinate.latitude, long: location.coordinate.longitude, distance: 150)
            .onSuccess { airportList in
                var markerDataList: [MarkerData] = []
                airportList.forEach { airport in
                    print("AIRPORT NAME: \(airport.name)\nAIRPORT LAT: \(airport.lat)\nAIRPORT LONG: \(airport.lng)")
                    let loc = CLLocation(latitude: airport.lat, longitude: airport.lng)
                    let md = MarkerData(location: loc, title: airport.name)
                    markerDataList.append(md)
                }
                
                self.addMarkers(markerDataList)
            }
            .onFailure { err in
                print("FAILED TO GET NEARBY AIRPORTS DUE TO: \(err.localizedDescription)")
            }
    }
    
    private func setupMap(_ location: CLLocation) {
        //activityIndicator.stopAnimating()
        mapView.centerCoordinate = location.coordinate
        /*
        MKCoordinateRegion mapRegion;
            mapRegion.center = mapView.userLocation.coordinate;
            mapRegion.span.latitudeDelta = 0.2;
            mapRegion.span.longitudeDelta = 0.2;

            [mapView setRegion:mapRegion animated: YES];
         */
        var region = MKCoordinateRegion()
        region.center = location.coordinate
        region.span.latitudeDelta = 0.2
        region.span.longitudeDelta = 0.2
        mapView.setRegion(region, animated: true)
    }
    
    private func addMarkers(_ markerData: [MarkerData]) {
        // TODO add whatever markers here such as charter company locations etc
        
        // Remove any current annotations
        if !mapView.annotations.isEmpty {
            mapView.removeAnnotations(mapView.annotations)
        }
        
        markerData.forEach { data in
            let annotation = MKPointAnnotation()
            annotation.coordinate = data.location.coordinate
            annotation.title = data.title
            if let annotationView = getViewForAnnotation(annotation: annotation) {
                mapView.addAnnotation(annotationView.annotation as? MKPointAnnotation ?? MKPointAnnotation())
            }
        }
        
    }
    
    private func getViewForAnnotation(annotation: MKPointAnnotation) -> MKAnnotationView? {
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "LocationPin")
        
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "LocationPin")
            annotationView?.canShowCallout = true
        } else {
            annotationView?.annotation = annotation
        }
        
        let image = #imageLiteral(resourceName: "aerojet")
        annotationView?.image = image
        //view.leftCalloutAccessoryView = UIImageView(image: )
        //view.annotation = annotation
        let offset = CGPoint(x: image.size.width / 2, y: -(image.size.height / 2) )
        annotationView?.centerOffset = offset
        return annotationView
        //} else {
         //   let annotView = MKAnnotationView(annotation: annotation, reuseIdentifier: "LocationPin")
           // annotView.canShowCallout = true
            //annotView.image = imgView.image
            //return annotView
       // }
    }
}

extension HomeViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard authorizationStatus != manager.authorizationStatus else { return }
        
        authorizationStatus = manager.authorizationStatus
        switch authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.requestLocation()
        default: setupMap(defaultLocation)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print("ALTITUDE: \(location.altitude) LATITUDE: \(location.coordinate.latitude) LONGITUDE: \(location.coordinate.longitude)")
            userLocation = location
            setupMap(location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("CLLocationManager did fail with error: \(error.localizedDescription)")
    }
}

extension HomeViewController: UITabBarDelegate {
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        switch item.tag {
        case 0:
            self.getNearbyAirports(self.userLocation ?? self.defaultLocation)
        case 1:
            guard let walletController: UserWalletViewController = UIStoryboard(name: "UserWallet", bundle: nil)
                .instantiateViewController(withIdentifier: "UserWallet") as? UserWalletViewController else { fatalError("Unable to instantiate UserWalletViewController") }
            self.navigationController?.pushViewController(walletController, animated: true)
            
        case 2:
            break
        case 3:
            break
        default:
            break
        }
    }
}

extension HomeViewController: NavigableViewController {
    var navBarStyle: NavigationBarStyle { return .hidden }
}

struct MarkerData {
    let location: CLLocation
    let title: String
}
