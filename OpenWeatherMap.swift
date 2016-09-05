//
//  OpenWeatherMap.swift
//  Weather-app
//
//  Created by Jinchao Luo on 16/8/29.
//  Copyright © 2016年 Jinchao Luo. All rights reserved.
//

import Foundation
import UIKit

protocol OpenWeatherMapDelegate {
    func updateWeather(temp:String, cityName:String, description:String, describe:String)
}

class OpenWeatherMap {
    
    
    var delegate: OpenWeatherMapDelegate!
    var cityName :String?
    var temp: String?
    var description:String?
    var describe:String?
 
    func getWeatherFor(latitude: Double, longitude: Double){
        
        //let cityString = city.stringByReplacingOccurrencesOfString(" ", withString: "")
        let url: NSURL = NSURL(string:"http://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=298274846a5252a9f1425de39d0345f5")!
        NSURLSession.sharedSession().dataTaskWithURL(url,completionHandler: {(data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            do{
                if let dict = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as? NSDictionary
                {
                    let main = dict["main"] as! NSDictionary
                    let kelvinTemp = main["temp"] as! Double
                    let temp = kelvinTemp - 273.15
                    //let temp = tempinfo["temp"]
                    let name = dict["name"] as! String
                    self.cityName = name
                    print(self.cityName)
                    
                    let wind = dict["wind"] as! NSDictionary
                    let description = wind["speed"] as! Double
                    self.description = String(format: "%.1f",description)
                    print(self.description)
                    
                    let weather = dict["weather"] as! NSArray
                    let weatherinfo = weather[0] as!NSDictionary
                    let describe = weatherinfo["main"] as! String
                    self.describe = describe
                    print(self.describe)
                    
                    // self.cityName = name!
                    self.temp = String(format:"%.1f", temp)
                    print(self.temp)
                    self.delegate.updateWeather(self.temp!,cityName: self.cityName!,description:self.description!,describe: self.describe!)
                    //self.description = description!
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
