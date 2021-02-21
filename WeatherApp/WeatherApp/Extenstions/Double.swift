//
//  String.swift
//  WeatherApp
//
//  Created by Akshay on 21/02/21.
//

import Foundation
import UIKit

extension Double {
    func getTempInDegreeCelecious() -> String {
        let measurement = Measurement(value: self, unit: UnitTemperature.celsius)

        let measurementFormatter = MeasurementFormatter()
        measurementFormatter.unitStyle = .short
        measurementFormatter.numberFormatter.maximumFractionDigits = 0
        measurementFormatter.unitOptions = .temperatureWithoutUnit
        
        return measurementFormatter.string(from: measurement)
    }
}
