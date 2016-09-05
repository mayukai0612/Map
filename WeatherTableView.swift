//
//  WeatherTableView.swift
//  Map
//
//  Created by Yukai Ma on 31/08/2016.
//  Copyright © 2016 Yukai Ma. All rights reserved.
//

import UIKit
import MapKit

class WeatherTableView: UITableViewController,addWeatherDelegate,weatherUpdateDelegate,CLLocationManagerDelegate{
    
    
    var weatherArray = [WeatherInfo]()
    var loadWeather:LoadWeather?
    let locationManager = CLLocationManager()
    var currentLocCoord: CLLocationCoordinate2D?
    
    @IBAction func addButton(sender: AnyObject) {
        
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("weatherSearch") as! WeatherSearch
        vc.delegate = self
      
        self.navigationController!.pushViewController(vc, animated: true)
        
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //test
        if(self.weatherArray.count > 0){
            print(self.weatherArray[0].location)
        }
        
        
        self.loadWeather = LoadWeather()
        self.loadWeather?.delegate = self
        
        
        //get current location 
        //show current location
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // using only when application is in use
        // self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        //change tableView row height
        self.tableView.rowHeight = 100

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //return numbers of sections
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //return number of cells
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
     
        return self.weatherArray.count

    }
    
    //In cellForRowAtIndexPath we need to work out which kind of cell we need.
    //If the section is 0 then we’ll define cells with customed cells
    //But if the section is 1 we just need a basic cell to display the total.
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
            let celldentifier = "weatherCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(celldentifier, forIndexPath: indexPath)as!WeatherCell
            
        
            // Configure the cell...
            let weather = self.weatherArray[indexPath.row]
            
            cell.locationLabel.text = weather.location
            cell.tempLabel.text = weather.temp
            cell.windLabel.text = weather.windSpeed

        //compare desc to determin weather image
        if(weather.weatherDesc?.caseInsensitiveCompare("clear") == NSComparisonResult.OrderedSame){
            //define background
            let imageView = UIImageView(frame: CGRectMake(0, 0, cell.frame.width , cell.frame.height))
            let image = UIImage(named: "Clear_bgp")
            imageView.image = image
            cell.backgroundView = UIView()
            cell.backgroundView!.addSubview(imageView)
            //define image
            cell.weatherImage.image = UIImage(named: "Clear")
        }
        
        if( weather.weatherDesc?.caseInsensitiveCompare("clouds") == NSComparisonResult.OrderedSame){
            
            //define background
            let imageView = UIImageView(frame: CGRectMake(0, 0, cell.frame.width , cell.frame.height))
            let image = UIImage(named: "Cloudy_bgp")
            imageView.image = image
            cell.backgroundView = UIView()
            cell.backgroundView!.addSubview(imageView)
            //wether image
            cell.weatherImage.image = UIImage(named: "Clouds")
        }
        
        if( weather.weatherDesc?.caseInsensitiveCompare("rain") == NSComparisonResult.OrderedSame){
            
            //define background
            let imageView = UIImageView(frame: CGRectMake(0, 0, cell.frame.width , cell.frame.height))
            let image = UIImage(named: "Rainy_bgp")
            imageView.image = image
            cell.backgroundView = UIView()
            cell.backgroundView!.addSubview(imageView)
            //wether image

            cell.weatherImage.image = UIImage(named: "Rain")
        }
        if( weather.weatherDesc?.caseInsensitiveCompare("snow") == NSComparisonResult.OrderedSame){
            
            
            //define background
           let imageView = UIImageView(frame: CGRectMake(0, 0, cell.frame.width , cell.frame.height))
            let image = UIImage(named: "Snow_bgp")
            imageView.image = image
            cell.backgroundView = UIView()
            cell.backgroundView!.addSubview(imageView)
            //wether image

            cell.weatherImage.image = UIImage(named: "Snow")
        }
        if( weather.weatherDesc?.caseInsensitiveCompare("storm") == NSComparisonResult.OrderedSame){
            
            //define background
            let imageView = UIImageView(frame: CGRectMake(0, 0, cell.frame.width , cell.frame.height))
            let image = UIImage(named: "Storm_bgp")
            imageView.image = image
            cell.backgroundView = UIView()
            cell.backgroundView!.addSubview(imageView)
            //wether image

            
            cell.weatherImage.image = UIImage(named: "Storm")
        }
        if( weather.weatherDesc?.caseInsensitiveCompare("drizzle") == NSComparisonResult.OrderedSame){
            
            
            //define background
            let imageView = UIImageView(frame: CGRectMake(0, 0, cell.frame.width , cell.frame.height))
            let image = UIImage(named: "drizzle_bgp")
            imageView.image = image
            cell.backgroundView = UIView()
            cell.backgroundView!.addSubview(imageView)
            //wether image

            cell.weatherImage.image = UIImage(named: "Drizzle")
        }

            return cell
     
    }
    
    
    
    
    // The canEditRowAtIndexPath method is used to work out if you can modify a certain row.
    //In this case we are saying that you can change rows in section 0 only.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    
    
    // Override to support delete todolist from current list
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            self.weatherArray.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    
//    //get the todolist in selected row and pass it to destination view controller
    //here I do not use segue. I use the storyboard to creat a new instance of view controller
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
    }
    

    
    func addChildView(popUpView: UIViewController)
    {
        //convert AnyClass to specific type
        
        self.addChildViewController(popUpView)
        popUpView.view.frame = self.view.frame
        self.view.addSubview(popUpView.view)
        popUpView.didMoveToParentViewController(self)
    }
    

    func addWeather(coordinate: CLLocationCoordinate2D) {
        self.loadWeather?.getWeatherFor(coordinate.latitude, longitude: coordinate.longitude)
    }
    
    func updateWeather(weather: WeatherInfo) {
        dispatch_async(dispatch_get_main_queue()) {
         
            if(self.weatherArray.count > 0){
            print(self.weatherArray[0].location)
            }
            
            for w: WeatherInfo in self.weatherArray{
                print(w.location)
            }
            
            self.weatherArray.append(weather)
            
            self.tableView.reloadData()
        }

     

    }
    
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        let center = CLLocationCoordinate2DMake(location!.coordinate.latitude,location!.coordinate.longitude)
        
        let region = MKCoordinateRegionMake(center, MKCoordinateSpanMake(0.5, 0.5))
        
        
        self.locationManager.stopUpdatingLocation()
        
        if(self.currentLocCoord == nil){
        currentLocCoord =  locations.last!.coordinate
        
        self.loadWeather?.getWeatherFor(currentLocCoord!.latitude, longitude: currentLocCoord!.longitude)

        }
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error" + error.localizedDescription)
    }
    


}
