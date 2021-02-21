//
//  WeatherInfoViewModel.swift
//  WeatherApp
//
//  Created by Akshay on 21/02/21.
//

import Foundation

class WeatherInfoViewModel {

    private var weatherInfoModel: WeatherInfoModel
    
    // values for view
    var cityName: String {
        return self.weatherInfoModel.cityName
    }
    
    var temprature: Double {
        return self.weatherInfoModel.temprature
    }
    
    var minimumTemprature: Double {
        return self.weatherInfoModel.minTemprature
    }

    var maximumTemprature: Double {
        return self.weatherInfoModel.maxTemprature
    }
    
    var timestamp: Date? {
        return self.weatherInfoModel.timeStamp
    }
    
    //other values
    var tempratureInDegreeCel: String {
        return self.temprature.getTempInDegreeCelecious()
    }
    
    var tempratureMinInDegreeCel: String {
        return self.minimumTemprature.getTempInDegreeCelecious()
    }
    
    var tempratureMaxInDegreeCel: String {
        return self.maximumTemprature.getTempInDegreeCelecious()
    }
    
    // Initalizer
    required init(with model: WeatherInfoModel = WeatherInfoModel()) {
        self.weatherInfoModel = model
    }
    
}

