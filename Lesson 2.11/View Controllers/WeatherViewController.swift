//
//  ViewController.swift
//  Lesson 2.10
//
//  Created by Kostya on 03.04.2022.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var feelsLikeLabel: UILabel!
    @IBOutlet var weatherImage: UIImageView!
    @IBOutlet var datetimeLabel: UILabel!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var forecastTableView: UITableView!
    @IBOutlet var mainStackView: UIStackView!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var windLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    @IBOutlet var pressureLabel: UILabel!

    private var forecasts: [Forecasts]!
    private var locationManager = CLLocationManager()
    private var latitude: CLLocationDegrees!
    private var longitude: CLLocationDegrees!
    private var testDisplay = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        initLocationManager()
        mainStackView.isHidden = true
        refreshWeather()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        latitude = locations.last?.coordinate.latitude
        longitude = locations.last?.coordinate.longitude
        testDisplay = false
        refreshWeather()
    }
}

//MARK: - Private Methods
extension WeatherViewController {
    
    private func refreshWeather() {
        let url = DataManager.shared.urlWeather + "&lat=\(latitude ?? 57.626560)&lon=\(longitude ?? 39.893806)"
        print(url)
        //let url = DataManager.shared.urlWeather + "&lat=\()&lon=\(39.893806)"
//        var url = ""
//        if latitude == nil || longitude == nil
//        {
//
//        } else {
//            url = DataManager.shared.urlWeather + "&lat=\(latitude!)&lon=\(longitude!)"
//
//        }
        
        NetworkManager.shared.fetchWeather(url: url) { result in
            switch result {
            case .success(let yandexWeather):
                self.setUI(from: yandexWeather)
            case .failure(let error):
                self.showAlert(with: "\(error.localizedDescription)")
            }
        }
    }
    
    private func getDayOfWeek(from dateTime: Double) -> String {
        let dateTimeFromString = Date(timeIntervalSince1970: dateTime)
        let dateFormatter = DateFormatter()
        
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEE")
        
        return dateFormatter.string(from: dateTimeFromString)
    }
    
    private func showAlert(with message: String){
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default)
            alertController.addAction(alertAction)
            self.present(alertController, animated: true)
        }
    }
    
    private func setUI(from yandexWeather: YandexWeather) {
        guard let temp = yandexWeather.fact?.temp else { return }
        guard let feelsLike = yandexWeather.fact?.feels_like else { return }
        guard let image = yandexWeather.fact?.icon else { return }
        guard let dayOfWeek = yandexWeather.now else { return }
        guard let forecasts = yandexWeather.forecasts else { return }
        guard let country = yandexWeather.geo_object?.country?.name else { return }
        guard let district = yandexWeather.geo_object?.province?.name else { return }
        guard let city = yandexWeather.geo_object?.locality?.name else { return }
        
        let wind = yandexWeather.fact?.windString
        let humidity = yandexWeather.fact?.humidityString
        let pressure = yandexWeather.fact?.pressureString
        
        if !testDisplay {
            self.locationLabel.text = "\(city), \(district), \(country)"
            self.locationLabel.textColor = .black
        } else {
            self.locationLabel.text = "Геопозиция не определена!Разрешите приложению доступ к геопозиции для отображения погоды для текущего местоположения"
            self.locationLabel.textColor = .red
        }
        self.tempLabel.text = "\(temp) ˚"
        self.feelsLikeLabel.text = "Ощущается как: \(feelsLike) ˚"
        self.weatherImage.image = UIImage.init(named: image)
        self.datetimeLabel.text = self.getDayOfWeek(from: dayOfWeek)
        self.windLabel.text = wind
        self.humidityLabel.text = humidity
        self.pressureLabel.text = pressure
        self.forecasts = forecasts
        
        self.activityIndicator.stopAnimating()
        self.mainStackView.isHidden = false
        
        self.forecastTableView.reloadData()
    }
    
    private func initLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
}


//MARK: - TableView methods
extension WeatherViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        forecasts != nil ? forecasts.count-1 : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: "forecastID", for: indexPath) as? ForecastTableViewCell else { return UITableViewCell.init()}
        let index = indexPath.row + 1
        guard let temp = forecasts[index].parts?.day?.temp_avg else { return cell }
        guard let icon = forecasts[index].parts?.day?.icon else { return cell }
        guard let dayOfWeek = forecasts[index].date_ts else { return cell }
        
        cell.weatherImage.image = UIImage(named: icon)
        cell.tempLabel.text = "\(temp)"
        cell.dayOfWeekLabel.text = getDayOfWeek(from: dayOfWeek)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
    
}
