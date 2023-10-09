//  ViewController.swift
//  appsWhether
//
//  Created by MacBook on 07/10/2023.
//
import UIKit
import SnapKit
import Alamofire
import Nuke

struct CurrentResponseStorage: Codable {
    var currentResponse: CurrentResponse?
}

struct ForecastResponseStorage: Codable {
    var forecastResponse: ForecastResponse?
}

class WeatherVC: UIViewController {
    
    var currentResponse: CurrentResponse?
    var forecastResponse: ForecastResponse?
    
    let weatherService = WeatherService.shared
    var forecastList = [Forecastday]()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    let cityTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Please you city"
        textField.backgroundColor = .white
        textField.textAlignment = .center
        textField.layer.cornerRadius = 5
        return textField
    }()
    
    lazy var searchButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .green
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Search", for: .normal)
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(searchButtonTap), for: .touchUpInside)
        return button
    }()
    
    let nameCityLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 30)
        return label
    }()
    
    let countryLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let backgroundImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "background"))
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let temperatureLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 50)
        return label
    }()
    
    let conditionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    let iconWeatherImage: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    func loadSavedData() {
        if let currentResponseData = UserDefaults.standard.data(forKey: "currentResponse"),
           let currentResponseStorage = try? JSONDecoder().decode(CurrentResponseStorage.self, from: currentResponseData) {
            if self.currentResponse == nil {
                currentResponse = currentResponseStorage.currentResponse
                countryLabel.text = currentResponse!.location.country
                nameCityLabel.text = currentResponse!.location.name
                let temperature = Int(currentResponse!.current.tempC)
                temperatureLabel.text = "\(temperature)°"
                conditionLabel.text = currentResponse!.current.condition.text
                if let url = URL(string: "https:\(currentResponse!.current.condition.icon)") {
                    Nuke.loadImage(with: url, into: self.iconWeatherImage)
                }
            }
        }
        if let forecastResponseData = UserDefaults.standard.data(forKey: "forecastResponse"),
           let forecastResponseStorage = try? JSONDecoder().decode(ForecastResponseStorage.self, from: forecastResponseData) {
            if self.forecastResponse == nil {
                self.forecastResponse = forecastResponseStorage.forecastResponse
                self.forecastList = forecastResponse!.forecast.forecastday
                self.tableView.reloadData()
            }
        }
    }
    
    func saveCurrentResponse(_ currentResponse: CurrentResponse) {
        let currentResponseStorage = CurrentResponseStorage(currentResponse: currentResponse)
        if let encodedData = try? JSONEncoder().encode(currentResponseStorage) {
            UserDefaults.standard.set(encodedData, forKey: "currentResponse")
            self.currentResponse = currentResponse
        }
    }
    
    func saveForecastResponse(_ forecastResponse: ForecastResponse) {
        let forecastResponseStorage = ForecastResponseStorage(forecastResponse: forecastResponse)
        if let encodedData = try? JSONEncoder().encode(forecastResponseStorage) {
            UserDefaults.standard.set(encodedData, forKey: "forecastResponse")
            self.forecastResponse = forecastResponse
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadSavedData()
        fetchWeatherData()
        fetchWeatherData2()
    }
    
    func fetchWeatherData() {
        guard let cityName = cityTextField.text else { return }
        weatherService.getWeathers(
            cityName: cityName, successCompletion: { [weak self] forecastResponse in
                self?.forecastList = forecastResponse.forecast.forecastday
                self?.tableView.reloadData()
                self?.saveForecastResponse(forecastResponse)
            },
            errorComletion: { error in
                print("Error fetching weather data: \(error)")
            }
        )
    }
    
    func fetchWeatherData2() {
        guard let cityName = cityTextField.text else { return }
        weatherService.getCurrentWeather(
            cityName: cityName, successCompletion: { [weak self] currentResponse in
                self?.countryLabel.text = currentResponse.location.country
                self?.nameCityLabel.text = currentResponse.location.name
                let temperature = Int(currentResponse.current.tempC)
                self?.temperatureLabel.text = "\(temperature)°"
                self?.conditionLabel.text = currentResponse.current.condition.text
                if let url = URL(string: "https:\(currentResponse.current.condition.icon)") {
                    Nuke.loadImage(with: url, into: self!.iconWeatherImage)
                }
                self?.saveCurrentResponse(currentResponse)
            },
            errorComletion: { error in
                print("Error fetching weather data: \(error)")
            }
        )
    }
    
    
    @objc func searchButtonTap() {
        fetchWeatherData()
        fetchWeatherData2()
    }
    
    func setupView() {
        view.addSubview(backgroundImageView)
        view.addSubview(cityTextField)
        view.addSubview(searchButton)
        view.addSubview(iconWeatherImage)
        view.addSubview(nameCityLabel)
        view.addSubview(countryLabel)
        view.addSubview(temperatureLabel)
        view.addSubview(conditionLabel)
        view.addSubview(iconWeatherImage)
        view.addSubview(tableView)
        
        backgroundImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        cityTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(50)
            make.centerX.equalToSuperview()
            make.width.equalTo(150)
            make.height.equalTo(25)
        }
        searchButton.snp.makeConstraints { make in
            make.top.equalTo(cityTextField.snp.bottom).offset(20)
            make.width.equalTo(100)
            make.height.equalTo(50)
            make.centerX.equalToSuperview()
        }
        nameCityLabel.snp.makeConstraints { make in
            make.top.equalTo(searchButton.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        countryLabel.snp.makeConstraints { make in
            make.top.equalTo(nameCityLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview()
        }
        
        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(countryLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        conditionLabel.snp.makeConstraints { make in
            make.top.equalTo(temperatureLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        iconWeatherImage.snp.makeConstraints { make in
            make.top.equalTo(conditionLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(64)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(iconWeatherImage.snp.bottom).offset(20)
            make.leading.trailing.bottom.equalToSuperview()
        }
        
        tableView.register(WeatherCell.self, forCellReuseIdentifier: WeatherCell.reuseId)
        tableView.dataSource = self
    }
    
}

extension WeatherVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return forecastList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WeatherCell.reuseId, for: indexPath)
        
        guard let weatherCell = cell as? WeatherCell else {
            return cell
        }
        
        let index = indexPath.row
        
        let forecast = forecastList[index]
        
        setupCell(weatherCell: weatherCell, forecast: forecast)
        
        return weatherCell
    }
    
    func setupCell(weatherCell: WeatherCell, forecast: Forecastday) {
        let dateString = forecast.date
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        let dayName: String
        
        if let date = dateFormatter.date(from: dateString) {
            let calendar = Calendar.current
            let dayOfWeek = calendar.component(.weekday, from: date)
            dayName = dateFormatter.weekdaySymbols[dayOfWeek - 1]
        } else {
            print("Неверный формат даты.")
            dayName = ""
        }
        weatherCell.dayLabel.text = dayName
        weatherCell.conditionLabel.text = forecast.day.condition.text
        let maxTemp = Int(forecast.day.maxtempC)
        let minTemp = Int(forecast.day.mintempC)
        weatherCell.maxTempLabel.text = "\(maxTemp)° / \(minTemp)°"
        if let url = URL(string: "https:\(forecast.day.condition.icon)") {
            Nuke.loadImage(with: url, into: weatherCell.iconImageView)
        }
        
    }
}
