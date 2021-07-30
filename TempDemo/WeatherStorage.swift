import Foundation

class WeatherStorage {    
    static func getWeatherStorage() -> [String: WeatherModel] {
        let weatherStorageData = Foundation.UserDefaults.standard.data(forKey: "WEATHER_STORAGE")
        if let weatherStorage = try? JSONDecoder().decode([String: WeatherModel].self, from: weatherStorageData ?? Data()) {
            UserDefaults.standard.setValue(weatherStorageData, forKey: "WEATHER_STORAGE")
            return weatherStorage
        }
        return [String: WeatherModel]()
    }
    
    static func setWeatherStorage(city: String, weatherModel: WeatherModel) {
        var weatherStorage = getWeatherStorage()
        weatherStorage[city] = weatherModel
        
        if let weatherStorageData = try? JSONEncoder().encode(weatherStorage ) {
            UserDefaults.standard.setValue(weatherStorageData, forKey: "WEATHER_STORAGE")
        }
    }
}
