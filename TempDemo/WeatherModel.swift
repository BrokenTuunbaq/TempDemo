import Foundation
import UIKit

// MARK: - WeatherModel
class WeatherModel: Codable {
    let lat, lon: Double
    var timezone: String
    let timezoneOffset: Int
    let current: Current
    let daily: [Daily]

    enum CodingKeys: String, CodingKey {
        case lat, lon, timezone
        case timezoneOffset = "timezone_offset"
        case current, daily
    }

    init(lat: Double, lon: Double, timezone: String, timezoneOffset: Int, current: Current, daily: [Daily]) {
        self.lat = lat
        self.lon = lon
        self.timezone = timezone
        self.timezoneOffset = timezoneOffset
        self.current = current
        self.daily = daily
    }
}

// MARK: - Current
class Current: Codable {
    let dt, sunrise, sunset: Int
    let temp, feelsLike: Double
    let pressure, humidity: Double
    let dewPoint, uvi: Double
    let clouds, visibility, windSpeed, windDeg: Double
    let windGust: Double
    let weather: [Weather]
    let rain: Rain
    let snow: Double

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case uvi, clouds, visibility
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case windGust = "wind_gust"
        case weather
        case rain = "rain"
        case snow = "snow"
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.dt = try values.decodeIfPresent(Int.self, forKey: .dt) ?? 0
        self.sunrise = try values.decodeIfPresent(Int.self, forKey: .sunrise) ?? 0
        self.sunset = try values.decodeIfPresent(Int.self, forKey: .sunset) ?? 0
        self.temp = try values.decodeIfPresent(Double.self, forKey: .temp) ?? 0
        self.feelsLike = try values.decodeIfPresent(Double.self, forKey: .feelsLike) ?? 0
        self.pressure = try values.decodeIfPresent(Double.self, forKey: .pressure) ?? 0
        self.humidity = try values.decodeIfPresent(Double.self, forKey: .humidity) ?? 0
        self.dewPoint = try values.decodeIfPresent(Double.self, forKey: .dewPoint) ?? 0
        self.uvi = try values.decodeIfPresent(Double.self, forKey: .uvi) ?? 0
        self.clouds = try values.decodeIfPresent(Double.self, forKey: .clouds) ?? 0
        self.visibility = try values.decodeIfPresent(Double.self, forKey: .visibility) ?? 0
        self.windSpeed = try values.decodeIfPresent(Double.self, forKey: .windSpeed) ?? 0
        self.windDeg = try values.decodeIfPresent(Double.self, forKey: .windDeg) ?? 0
        self.weather = try values.decodeIfPresent([Weather].self, forKey: .weather) ?? [Weather]()
        self.windGust = try values.decodeIfPresent(Double.self, forKey: .windGust) ?? 0
        self.rain = try values.decodeIfPresent(Rain.self, forKey: .rain) ?? Rain()
        self.snow = try values.decodeIfPresent(Double.self, forKey: .snow) ?? 0
    }
}

class Rain: Codable {
    let the1H: Double

    enum CodingKeys: String, CodingKey {
        case the1H = "1h"
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.the1H = try values.decodeIfPresent(Double.self, forKey: .the1H) ?? 0
    }
    
    init() {
        self.the1H = 0
    }
}

// MARK: - Weather
class Weather: Codable {
    let id: Int
    let main, weatherDescription, icon: String
    var iconImg = UIImage()

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }

    init(id: Int, main: String, weatherDescription: String, icon: String) {
        self.id = id
        self.main = main
        self.weatherDescription = weatherDescription
        self.icon = icon
    }
}

// MARK: - Daily
class Daily: Codable {
    let dt: Int
    let sunrise, sunset, moonrise: Double
    let moonset: Double
    let moonPhase: Double
    let temp: Temp
    let feelsLike: FeelsLike
    let pressure, humidity: Double
    let dewPoint, windSpeed: Double
    let windDeg: Double
    let windGust: Double?
    let weather: [Weather]
    let clouds: Int
    let pop: Double
    let rain: Double?
    let snow: Double?
    let uvi: Double

    enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, moonrise, moonset
        case moonPhase = "moon_phase"
        case temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case windGust = "wind_gust"
        case weather, clouds, pop, rain, uvi
        case snow = "snow"
    }

    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.dt = try values.decodeIfPresent(Int.self, forKey: .dt) ?? 0
        self.sunrise = try values.decodeIfPresent(Double.self, forKey: .sunrise) ?? 0
        self.sunset = try values.decodeIfPresent(Double.self, forKey: .sunset) ?? 0
        self.moonrise = try values.decodeIfPresent(Double.self, forKey: .moonrise) ?? 0
        self.moonset = try values.decodeIfPresent(Double.self, forKey: .moonset) ?? 0
        self.moonPhase = try values.decodeIfPresent(Double.self, forKey: .moonPhase) ?? 0
        self.temp = try values.decodeIfPresent(Temp.self, forKey: .temp) ?? Temp()
        self.feelsLike = try values.decodeIfPresent(FeelsLike.self, forKey: .feelsLike) ?? FeelsLike()
        self.pressure = try values.decodeIfPresent(Double.self, forKey: .pressure) ?? 0
        self.humidity = try values.decodeIfPresent(Double.self, forKey: .humidity) ?? 0
        self.dewPoint = try values.decodeIfPresent(Double.self, forKey: .dewPoint) ?? 0
        self.uvi = try values.decodeIfPresent(Double.self, forKey: .uvi) ?? 0
        self.clouds = try values.decodeIfPresent(Int.self, forKey: .clouds) ?? 0
        self.windSpeed = try values.decodeIfPresent(Double.self, forKey: .windSpeed) ?? 0
        self.windDeg = try values.decodeIfPresent(Double.self, forKey: .windDeg) ?? 0
        self.weather = try values.decodeIfPresent([Weather].self, forKey: .weather) ?? [Weather]()
        self.windGust = try values.decodeIfPresent(Double.self, forKey: .windGust) ?? 0
        self.rain = try values.decodeIfPresent(Double.self, forKey: .rain) ?? 0
        self.pop = try values.decodeIfPresent(Double.self, forKey: .pop) ?? 0
        self.snow = try values.decodeIfPresent(Double.self, forKey: .snow) ?? 0
    }
    
    init(dt: Int, sunrise: Double, sunset: Double, moonrise: Double, moonset: Double, moonPhase: Double, temp: Temp, feelsLike: FeelsLike, pressure: Double, humidity: Double, dewPoint: Double, windSpeed: Double, windDeg: Double, windGust: Double?, weather: [Weather], clouds: Int, pop: Double, rain: Double?, snow: Double?, uvi: Double) {
        self.dt = dt
        self.sunrise = sunrise
        self.sunset = sunset
        self.moonrise = moonrise
        self.moonset = moonset
        self.moonPhase = moonPhase
        self.temp = temp
        self.feelsLike = feelsLike
        self.pressure = pressure
        self.humidity = humidity
        self.dewPoint = dewPoint
        self.windSpeed = windSpeed
        self.windDeg = windDeg
        self.windGust = windGust
        self.weather = weather
        self.clouds = clouds
        self.pop = pop
        self.rain = rain
        self.uvi = uvi
        self.snow = snow
    }
}

// MARK: - FeelsLike
class FeelsLike: Codable {
    let day, night, eve, morn: Double

    init(day: Double, night: Double, eve: Double, morn: Double) {
        self.day = day
        self.night = night
        self.eve = eve
        self.morn = morn
    }
    
    init() {
        self.day = 0
        self.night = 0
        self.eve = 0
        self.morn = 0
    }
}

// MARK: - Temp
class Temp: Codable {
    let day, min, max, night: Double
    let eve, morn: Double

    init(day: Double, min: Double, max: Double, night: Double, eve: Double, morn: Double) {
        self.day = day
        self.min = min
        self.max = max
        self.night = night
        self.eve = eve
        self.morn = morn
    }
    
    init() {
        self.day = 0
        self.min = 0
        self.max = 0
        self.night = 0
        self.eve = 0
        self.morn = 0
    }
}
