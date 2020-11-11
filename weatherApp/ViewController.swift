//
//  ViewController.swift
//  weatherApp
//
//  Created by Eugene sch on 9/22/20.
//

import UIKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var spiner: UIActivityIndicatorView!
    @IBOutlet weak var temperatureLabel: UILabel?
    @IBOutlet weak var wind_speedLabel: UILabel?
    @IBOutlet weak var cityField: UITextField?
    @IBOutlet weak var typeLabel: UILabel?
    @IBOutlet weak var locatinLabel: UILabel?
    @IBOutlet weak var humidityLabel: UILabel?
    @IBOutlet weak var precipLabel: UILabel?
    
    
    private var viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.config()
        bind()
    }
    
    func bind(){
        self.viewModel.cityField.bind { (text) in
            self.cityField?.text = text
        }
        self.viewModel.spinerIsHidden.bind { (isHidden) in
            self.spiner.isHidden = isHidden
        }
        self.viewModel.temperatureLabel.bind { (text) in
            self.temperatureLabel?.text = text
        }
        self.viewModel.wind_speedLabel.bind { (text) in
            self.wind_speedLabel?.text = text + " m/s"
        }
        self.viewModel.humidityLabel.bind { (text) in
            self.humidityLabel?.text = text + " %"
        }
        self.viewModel.precipLabel.bind { (text) in
            self.precipLabel?.text = text + " %"
        }
        self.viewModel.typeLabel.bind { (text) in
            self.typeLabel?.text = text
        }
        self.viewModel.locatinLabel.bind { (text) in
            self.locatinLabel?.text = text
        }
    }
    
    @IBAction func refreshData(_ sender: UIButton) {
        guard let cityText = self.cityField?.text else {return}
        viewModel.refreshData(city: cityText)
    }
    
    @IBAction func currentLocationAction(_ sender: Any) {
        viewModel.currentLocationAction()
    }
    
}
