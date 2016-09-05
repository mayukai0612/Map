//
//  WeatherInfo.swift
//  Map
//
//  Created by Yukai Ma on 31/08/2016.
//  Copyright © 2016 Yukai Ma. All rights reserved.
//

import UIKit

class WeatherInfo: NSObject {

    var temp:String?

    var location:String?
    var windSpeed: String?
    var weatherDesc: String?
    
    override init() {
        
    }
    
    init(temp:String,location:String,windSpeed:String,weatherDesc:String) {
        self.temp = temp
        self.location = location
        self.windSpeed = windSpeed
        self.weatherDesc = weatherDesc
    }
    
    
    
    
    

    
    
    
    
}
