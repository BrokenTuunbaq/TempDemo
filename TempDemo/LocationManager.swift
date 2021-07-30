import Foundation
import CoreLocation

typealias currentPlacemarkClosure = (CLPlacemark) -> ()

class LocationManager: NSObject, CLLocationManagerDelegate {
    
    var currentPlacemark: currentPlacemarkClosure?
    let locationManager = CLLocationManager()
    
    func getLocation() {
        currentLocation()
    }
    
    func locationManagerDidChangeAuthorization(_ managero: CLLocationManager) {
        currentLocation()
    }
    
    func currentLocation() {
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            
            let geocoder = CLGeocoder()
            if let currentLocation = locationManager.location {
                geocoder.reverseGeocodeLocation(currentLocation) {
                    [weak self]
                    placemarks, error in
                    guard let placemark = placemarks?[0] else { return }
                    self?.currentPlacemark?(placemark)
                }
            }
        }
    }
}
