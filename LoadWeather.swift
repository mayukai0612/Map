//
//  OpenWeatherMap.swift
//  Weather-app
//
//  Created by Jinchao Luo on 16/8/29.
//  Copyright © 2016年 Jinchao Luo. All rights reserved.
//

import UIKit

protocol weatherUpdateDelegate {
    func updateWeather(weather:WeatherInfo)
}

class LoadWeather {
    
    
    var delegate: weatherUpdateDelegate?
    
    func getWeatherFor(latitude: Double, longitude: Double) {
        

        let url: NSURL = NSURL(string:"http://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=298274846a5252a9f1425de39d0345f5")!
        NSURLSession.sharedSession().dataTaskWithURL(url,completionHandler: {(data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            do{
                if let dict = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as? NSDictionary
                {
                    let main = dict["main"] as! NSDictionary
                    let kelvinTemp = main["temp"] as! Double
                    let temp = kelvinTemp - 273.15
                    
                    //get city name
                    let name = dict["name"] as! String
                //weatherPara!.location = name
                    
                    //get wind speed
                    let wind = dict["wind"] as! NSDictionary
                    let windspeed = wind["speed"] as! Double
                   let windSpeedStr = String(format: "%.1f",windspeed)
                    
                    //desc
                    let weather = dict["weather"] as! NSArray
                    let weatherinfo = weather[0] as!NSDictionary
                    let describe = weatherinfo["main"] as! String
                    //let weatherDesc = describe
                    
                    //temp
                    let weatherTemp = String(format:"%.1f", temp)
                    
                    let weatherPara = WeatherInfo(temp:weatherTemp,location:name,windSpeed:windSpeedStr,weatherDesc:describe)
                  
                    self.delegate?.updateWeather(weatherPara)
                    
                }
                
            }
            catch let error as NSError{
                print("error")
                print(error.localizedDescription)
                
            }
        })
            .resume()
    }
    
}
