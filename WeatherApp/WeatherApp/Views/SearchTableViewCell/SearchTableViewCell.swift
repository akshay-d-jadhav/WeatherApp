//
//  SearchTableViewCell.swift
//  WeatherApp
//
//  Created by Akshay on 21/02/21.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    static let identifier = "SearchTableViewCell"

    var weatherInfo: WeatherInfoViewModel? {
        didSet {
            if let weatherInfo = self.weatherInfo {
                cityNameLabel.text = weatherInfo.cityName
                minTempLabel.text = weatherInfo.tempratureMinInDegreeCel
                maxTempLabel.text = weatherInfo.tempratureMaxInDegreeCel
                
                if let timeStamp = weatherInfo.timestamp {
                    timeStampLabel.isHidden = false
                    timeStampLabel.text = timeStamp.getTimeString()
                } else {
                    timeStampLabel.isHidden = true
                }
                
            }
        }
    }
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
