//
//  WeatherInfoModel.swift
//  WeatherApp
//
//  Created by Akshay on 21/02/21.
//

import Foundation
import SwiftyJSON

class WeatherInfoModel {
    
    var cityName: String = ""
    var temprature: Double = 0.0
    var minTemprature: Double = 0.0
    var maxTemprature: Double = 0.0
    var timeStamp: Date?
    
    init() {
        
    }
    
    init(json: JSON) {
        
        if let name = json["name"].string {
            self.cityName = name
        }
        
        let main = json["main"]
        
        if let temprature = main["temp"].double {
            self.temprature = temprature
        }
        
        if let minTemprature = main["temp_min"].double {
            self.minTemprature = minTemprature
        }
        
        if let maxTemprature = main["temp_max"].double {
            self.maxTemprature = maxTemprature
        }
        
        self.timeStamp = Date()
    }
    
    init(weatherInfo: WeatherInfo) {
        
        if let name = weatherInfo.cityName {
            self.cityName = name
        }
        
        self.temprature = weatherInfo.temprature
        
        self.minTemprature = weatherInfo.temprature_min
        
        self.maxTemprature = weatherInfo.temprature_max
        
        if let timeStamp = weatherInfo.timestamp {
            self.timeStamp = timeStamp
        }
        
    }
    
}
