import UIKit

class ForecastTabController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var cityNameLbl: UILabel!
    @IBOutlet weak var forecastTbl: UITableView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(false)

        cityNameLbl.text = WeatherStorage.getWeatherStorage()[MainTabController.cityDetectedName]?.timezone
        forecastTbl.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ForecastCell") as! ForecastCell
        let weatherStorage =  WeatherStorage.getWeatherStorage()[MainTabController.cityDetectedName]
        if weatherStorage == nil { return cell }
        cell.temperatureLbl.text = weatherStorage?.daily[indexPath.row].temp.day.description ?? "- " + "℃"
        let dateUnix = weatherStorage?.daily[indexPath.row].dt
        let date = NSDate(timeIntervalSince1970: TimeInterval(dateUnix!))
        let cal = Calendar.current
        cell.dateLbl.text = cal.component(.day, from: date as Date).description + "/" + cal.component(.month, from: date as Date).description + "/" + cal.component(.year, from: date as Date).description
        cell.adviceCommentLbl.text = weatherStorage?.daily[indexPath.row].weather[0].weatherDescription
        
        if let url = URL(string: "http://openweathermap.org/img/wn/" + (weatherStorage?.daily[indexPath.row].weather[0].icon)! + "@2x.png") {
            let taskIcon = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else { return }
                DispatchQueue.main.async {
                    cell.iconImgView.image = UIImage(data: data)
                    weatherStorage?.daily[indexPath.row].weather[0].iconImg = UIImage(data: data)!
                }
            }
            taskIcon.resume()
        }
        return cell
    }
}
