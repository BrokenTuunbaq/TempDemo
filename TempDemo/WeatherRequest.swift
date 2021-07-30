import Foundation

typealias weatherResponseClosure = (Data, String, WeatherModel) -> ()

class WeatherRequest {
    
    var weatherResponse: weatherResponseClosure?
    
    func requestCityWeather(city: String) {
        guard let location = CityLocation.locationByCity[city] else { return }
        let lat = location.coordinate.latitude.description
        let lon = location.coordinate.longitude.description
        
        let weatherRequestStr = "https://api.openweathermap.org/data/2.5/onecall?lat=" + lat + "&lon=" + lon + "&exclude=hourly,minutely,alerts&units=metric&lang=ru&appid=373e722f54bd310e41df590b46f71c37"
        
        let url = URL(string: weatherRequestStr)!
        var request = URLRequest(url: url)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let weatherResponse = try? JSONDecoder().decode(WeatherModel.self, from: data) {
                    WeatherStorage.setWeatherStorage(city: city, weatherModel: weatherResponse)
                    if let url = URL(string: "http://openweathermap.org/img/wn/" + weatherResponse.current.weather[0].icon + "@2x.png") {
                        let taskIcon = URLSession.shared.dataTask(with: url) { data, response, error in
                            guard let data = data, error == nil else { return }
                            self.weatherResponse?(data, city, weatherResponse)
                        }
                        taskIcon.resume()
                    }
                }
            }
        }
        task.resume()
    }
}
