//
//  ViewModel.swift
//  weatherApp
//
//  Created by Eugene sch on 10/27/20.
//

import Foundation
import CoreLocation

class ViewModel: NSObject {
    
    private let API_ACCESS_KEY = "65366cce655fb7ef8e2affbb6382018f"
    private let API_URL = "http://api.weatherstack.com"
    
    private var locationManager = CLLocationManager()
    private var coordinate: CLLocationCoordinate2D?
    
    private var city = "minsk"
    private var data: WeatherResponce?
    
    var spinerIsHidden: Bindable<Bool> = Bindable(false)
    var cityField: Bindable<String> = Bindable("")
    var timeLabel: Bindable<String> = Bindable("")
    var temperatureLabel: Bindable<String> = Bindable("")
    var wind_speedLabel: Bindable<String> = Bindable("")
    var wind_degreeLabel: Bindable<String> = Bindable("")
    var visibilityLabel: Bindable<String> = Bindable("")
    var humidityLabel: Bindable<String> = Bindable("")
    var precipLabel: Bindable<String> = Bindable("")
    var typeLabel: Bindable<String> = Bindable("")
    var locatinLabel: Bindable<String> = Bindable("")
    
    func config(){
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        self.city = UserDefaults.standard.string(forKey: "city") ?? "minsk"
        self.sendRequest(query: self.city)
        
    }
    
    func refreshData(city: String){
        self.city = city.replacingOccurrences(of: " ", with: "%20")
        if self.city.count < 2 {
            return
        }
        
        self.sendRequest(query: self.city)
    }
    
    func currentLocationAction(){
        guard let latitude = coordinate?.latitude,
              let longitude = coordinate?.longitude else {return}
        self.sendRequest(query: String(latitude) + "," + String(longitude))
    }
    
    
    //MARK: private func
    
    private func sendRequest(query: String) {
        print(query)
        guard let url = URL(string: self.API_URL + "/current?access_key=" + self.API_ACCESS_KEY + "&query=" + query ) else {
            return
        }
        self.spinerIsHidden.value = false
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if error == nil, let data = data {
                do {
                    self.data = try JSONDecoder().decode(WeatherResponce.self, from: data)
                    self.loadData()
                } catch {
                    print(error)
                }
            } else {
                print(error?.localizedDescription ?? "error kakoito")
                self.spinerIsHidden.value = true
            }
        }
        task.resume()
    }
    
    private func loadData() {
        guard let data = self.data else { return }
        
        let current = data.current
        self.city = data.location.name ?? "Current Location"
        UserDefaults.standard.set(self.city, forKey: "city")
        DispatchQueue.main.async {
            self.timeLabel.value = current.observation_time ?? ""
            self.temperatureLabel.value = String(current.temperature ?? 0)
            self.wind_speedLabel.value = String(current.wind_speed ?? 0)
            self.wind_degreeLabel.value = String(current.wind_degree ?? 0)
            self.visibilityLabel.value = String(current.visibility ?? 0)
            self.humidityLabel.value = String(current.humidity ?? 0)
            self.precipLabel.value = String(current.precip ?? 0)
            
            self.spinerIsHidden.value = true
            self.typeLabel.value = current.weather_descriptions?.first ?? ""
            self.locatinLabel.value = self.city
        }
    }
}

extension ViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location else { return }
        self.coordinate = location.coordinate
    }
}

