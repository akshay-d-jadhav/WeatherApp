//
//  ViewController.swift
//  WeatherApp
//
//  Created by Akshay on 21/02/21.
//

import UIKit
import SwiftyJSON
import Alamofire

class ViewController: UIViewController {

    @IBOutlet weak var weatherInfoContainerView: UIView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var tempratureLabel: UILabel!
    @IBOutlet weak var minimumTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    
    @IBOutlet weak var recentSearchContainerView: UIView!
    @IBOutlet weak var noSearchLabel: UILabel!
    @IBOutlet weak var recentSearchTableView: UITableView!
    @IBOutlet weak var searchContainerView: UIView!
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var activityContainerView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var recentSearchList: [WeatherInfoViewModel] = [WeatherInfoViewModel]()
    var filteredArray: [WeatherInfoViewModel] = [WeatherInfoViewModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // setup search text field
        self.setupSearchTextField()
        
        // setup recent search tableview
        self.setupRecentTableView()
        
        // load recent search results from local data
        self.loadRecentSearchResults()
        
        // featch pune weather as default value
        self.getWeatherInfo(cityName: "Pune")
    }


    // MARK: - IBOutlets
    // On tap search button
    @IBAction func onTapSearchButton(_ sender: Any) {
        self.searchWeatherInfo()
    }
    
    @IBAction func searchTextDidChange(_ sender: UITextField) {
        
        if let text = sender.text {
            
            if text == "" {
                self.filteredArray = self.recentSearchList
            } else {
                self.filteredArray = self.recentSearchList.filter({ $0.cityName.contains(text) })
            }
            
            if self.filteredArray.count > 0 {
                self.recentSearchTableView.isHidden = false
                self.recentSearchTableView.reloadData()
            } else {
                self.recentSearchTableView.isHidden = true
            }
            
        } else {
            self.recentSearchContainerView.isHidden = true
        }
    }
    
    // MARK: - User Define Methods
    func setupSearchTextField() {
        self.searchTextField.delegate = self
        
        let searchTextFieldToolbar = UIToolbar(frame:CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        searchTextFieldToolbar.barStyle = .default
        searchTextFieldToolbar.items = [
            UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(endSearch)),
            UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyBoard))]
        
        searchTextField.inputAccessoryView = searchTextFieldToolbar
    }
    
    @objc func dismissKeyBoard() {
        self.searchTextField.resignFirstResponder()
    }
    
    @objc func endSearch() {
        self.searchTextField.resignFirstResponder()
        self.recentSearchContainerView.isHidden = true
    }
    
    func setupRecentTableView() {
        self.recentSearchTableView.delegate = self
        self.recentSearchTableView.dataSource = self
        
        self.recentSearchTableView.register(UINib(nibName: SearchTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: SearchTableViewCell.identifier)
        
        self.recentSearchTableView.tableFooterView = UIView()
    }
    
    func loadRecentSearchResults() {
        self.recentSearchList = CoreDataManager.shared.getRecentSearchResults()
        
        if self.recentSearchList.count > 0 {
            self.recentSearchTableView.isHidden = false
            self.filteredArray = self.recentSearchList
            self.recentSearchTableView.reloadData()
        }
    }
    
    func displayWeatherDetails(weatherInfo: WeatherInfoViewModel) {
        self.cityNameLabel.text = weatherInfo.cityName
        self.tempratureLabel.text = weatherInfo.tempratureInDegreeCel
        self.minimumTempLabel.text = weatherInfo.tempratureMinInDegreeCel
        self.maxTempLabel.text = weatherInfo.tempratureMaxInDegreeCel
        self.searchTextField.text = weatherInfo.cityName
    }
    
    func displayRecentTableView() {
        self.recentSearchContainerView.isHidden = false
    }
    
    func displayNoResultLabel() {
        self.recentSearchTableView.isHidden = true
        self.noSearchLabel.isHidden = false
    }
    
    func hideNoResultLabel() {
        self.recentSearchTableView.isHidden = false
        self.noSearchLabel.isHidden = true
    }
    
    func searchWeatherInfo() {
        if let searchText = self.searchTextField.text {
            // Trim search text to avoid empty inputs
            if searchText.trimmingCharacters(in: .whitespacesAndNewlines).count > 0 {
                
                self.searchTextField.resignFirstResponder()
                self.recentSearchContainerView.isHidden = true
                self.getWeatherInfo(cityName: searchText.replacingOccurrences(of: " ", with: ""))
                self.loadRecentSearchResults()
                
            } else {
                self.showAlert(message: "Please enter city name")
            }
        } else {
            self.showAlert(message: "Please enter city name")
        }
    }
    
    func showAlert(message:String) {

        let alert = UIAlertController(title: "WeatherApp", message: message, preferredStyle: UIAlertController.Style.alert)

        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))

        self.present(alert, animated: true, completion: nil)
    }
    
    func displayActivityIndicator() {
        self.activityContainerView.isHidden = false
        self.activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator()  {
        self.activityContainerView.isHidden = true
        self.activityIndicator.stopAnimating()
    }
    
    // MARK: - API Calls
    func getWeatherInfo(cityName: String) {
        let url = "https://api.openweathermap.org/data/2.5/weather?q=" + cityName + "&units=metric&appid=094aa776d64c50d5b9e9043edd4ffd00"
        
        self.displayActivityIndicator()
        
        Alamofire.request(url, method: .get)
            .responseJSON { [weak self] response in
                
                guard let this = self else {
                    return
                }
                
                if response.data != nil {
                    let json = JSON(response.data!)
                    
                    if let message = json["message"].string {
                        this.showAlert(message: message)
                    } else {
                        
                        let weatherInfo = WeatherInfoViewModel(with: WeatherInfoModel(json: json))
                        CoreDataManager.shared.saveWeatherInfo(weatherInfo: weatherInfo)
                        this.displayWeatherDetails(weatherInfo: weatherInfo)
                    }
                    
                } else {
                    this.showAlert(message: "Sorry Data not found")
                }
                
                this.hideActivityIndicator()
            }
    }

}

// MARK: - TextField Delegates
extension ViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.loadRecentSearchResults()
        self.recentSearchContainerView.isHidden = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchWeatherInfo()
        return true
    }
    
}

// MARK: - TableView Delegates
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.identifier, for: indexPath) as! SearchTableViewCell
        
        cell.weatherInfo = self.filteredArray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchTextField.text = self.filteredArray[indexPath.row].cityName
        self.searchTextField.resignFirstResponder()
        self.recentSearchContainerView.isHidden = true
        self.displayWeatherDetails(weatherInfo: self.filteredArray[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
