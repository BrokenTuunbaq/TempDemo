import Foundation
import CoreLocation

class CityLocation {
    static var locationByCity: [String: CLLocation] = [ "Самара": CLLocation(latitude: 53.12, longitude: 50.08),
                                  "Новосибирск": CLLocation(latitude: 55.03, longitude: 82.57),
                                  "Магнитогорск": CLLocation(latitude: 53.23, longitude: 59.02),
                                  "Владивосток": CLLocation(latitude: 43.07, longitude: 131.54),
                                  "Омск": CLLocation(latitude: 54.58, longitude: 73.23) ]
}
