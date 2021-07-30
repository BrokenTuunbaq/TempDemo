import UIKit
import CoreLocation

class MainTabController: UIViewController {
    
    @IBOutlet weak var userCoordinatesLbl: UILabel!
    @IBOutlet weak var temperatureLbl: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var weatherDescription: UILabel!
    var locationManager: LocationManager?
    static var cityDetectedName = ""
    var weatherRequest = WeatherRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = LocationManager()
        locationManager?.getLocation()
        
        locationManager?.currentPlacemark = { [weak self]
            placemark in
            guard let locality = placemark.locality else { return }
            MainTabController.cityDetectedName = locality
            CityLocation.locationByCity[MainTabController.cityDetectedName] = placemark.location
            self?.userCoordinatesLbl.text = MainTabController.cityDetectedName
            self?.selectCity(city: MainTabController.cityDetectedName)
        }
    }
    
    @IBAction func samaraBtn(_ sender: Any) {
        selectCity(city: "Самара")
    }
    
    @IBAction func novosibirskBtn(_ sender: Any) {
        selectCity(city: "Новосибирск")
    }
    
    @IBAction func magnitogorskBtn(_ sender: Any) {
        selectCity(city: "Магнитогорск")
    }
    
    @IBAction func vladivostokBtn(_ sender: Any) {
        selectCity(city: "Владивосток")
    }
    
    @IBAction func omskBtn(_ sender: Any) {
        selectCity(city: "Омск")
    }
    
    func updateUI(imageData: Data, city: String, weatherResponse: WeatherModel) {
        DispatchQueue.main.async {
            self.weatherIcon.image = UIImage(data: imageData)
            let weatherStorage = WeatherStorage.getWeatherStorage()
            weatherStorage[city]?.current.weather[0].iconImg = self.weatherIcon.image ?? UIImage()
            WeatherStorage.setWeatherStorage(city: city, weatherModel: weatherStorage[city]!)
            self.temperatureLbl.text = Int(weatherResponse.current.temp).description + "℃"
            self.weatherDescription.text = weatherResponse.current.weather[0].weatherDescription
            self.tabBarController?.tabBar.items?[1].isEnabled = true
        }
    }
    
    func updateUIFromStorage(city: String) {
        let weatherStorage = WeatherStorage.getWeatherStorage()
        let weatherModel = weatherStorage[city]
        guard weatherModel != nil else { return }
        DispatchQueue.main.async {
            self.weatherIcon.image = weatherModel?.current.weather[0].iconImg
            self.temperatureLbl.text = Int(weatherModel?.current.temp ?? 0).description + "℃"
            self.weatherDescription.text = weatherModel?.current.weather[0].weatherDescription
            self.tabBarController?.tabBar.items?[1].isEnabled = true
        }
    }
    
    func selectCity(city: String) {
        MainTabController.cityDetectedName = city
        userCoordinatesLbl.text = MainTabController.cityDetectedName
        updateUIFromStorage(city: city)
        weatherRequest.weatherResponse = {
            data, city, weatherModel in
            self.updateUI(imageData: data, city: city, weatherResponse: weatherModel)
        }
        weatherRequest.requestCityWeather(city: city)
    }
}
