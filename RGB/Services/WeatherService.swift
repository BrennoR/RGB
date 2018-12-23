//
//  WeatherService.swift
//  RGB
//
//  Created by Brenno Ribeiro on 12/4/18.
//  Copyright © 2018 Brenno Ribeiro. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

var currentTemperature: String = "-"
var currentHumidity: String = "-"

class WeatherService {
    
    static let instance = WeatherService()
    
    let apiKey = "50fad32932336180d2a72f980aba3c3d"
    
    func getWeatherData(urlString: String) {
        
        let url = "\(urlString)&APPID=\(apiKey)"
        
        Alamofire.request(url).responseJSON { response in
            if response.result.error == nil {
                guard let data = response.data else { return }
                do {
                    let json = try JSON(data: data)
                    let main = json["main"]
//                    print(main)
                    currentTemperature = String(format: "%.1f", main["temp"].double! - 273.15)
                    currentHumidity = String(main["humidity"].int!)
                } catch {
                    debugPrint(error)
                    currentTemperature = "N/A"
                    currentHumidity = "N/A"
                }
            } else {
                debugPrint(response.result.error as Any)
            }
        }
    }
    
}
