//
//  ViewController.swift
//  Map
//
//  Created by Yukai Ma on 4/08/2016.
//  Copyright © 2016 Yukai Ma. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol AlertDelegate {
    func showAlert()
}


class SearchFromDB: NSObject, MKMapViewDelegate{
    
    
    var selectedPin:MKPlacemark? = nil
    
    var animalInfomations: NSMutableArray? = NSMutableArray()
    
    var classifiedData = [Int:NSMutableArray]()
    
    var navigationController:UINavigationController?
    
    var Map: MKMapView?
    
    var coordinate: CLLocationCoordinate2D?
  
    var alertDelegate: AlertDelegate?
    
    var currentLoc: CLLocationCoordinate2D?

   
    func loadDataByLocation(animalName: String,coordinate:CLLocationCoordinate2D,distacnce: Int ,time: String)
    {
        
        //Clear the space of animalInformations
        
        animalInfomations?.removeAllObjects()
        
        //Write reques URL
        let request = NSMutableURLRequest(URL: NSURL(string: "http://173.255.245.239/DangerousAnimals/GetNearLocations.php")!)
        
        request.HTTPMethod = "POST"
        
        let timePara = converTimePara(time)
        let postString = "latitude=\(coordinate.latitude)&longitude=\(coordinate.longitude)&animalName=\(animalName)&distance=\(distacnce)&time=\(timePara)"
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        // Excute HTTP Request
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request, completionHandler: { (data, response, error) in
            // do stuff with response, data & error here
            
            // Check for error
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            // Print out response string
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
         
            
            let trimmedString = responseString!.stringByTrimmingCharactersInSet(
                NSCharacterSet.whitespaceAndNewlineCharacterSet()
            )
            
            if (responseString == "null\n" || trimmedString == "null")
            {
                print("nullll")
                self.alertDelegate?.showAlert()
                return
            }
            
            // Convert server json response to NSArray
            do {
                if let animalInfoArray = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions()) as? NSArray {
                    
                    // Print out array
                    for animalInfo in animalInfoArray
                    {
                        
                        //convert Anyobject to a particular object type
                      //  let id = animalInfo["AnimalId"]!!.integerValue
                        
                        let name = animalInfo["VernacularName"]as?String
                        
                        let lat = animalInfo["Latitude"]!!.doubleValue
                        
                        let lgt = animalInfo["Longitude"]!!.doubleValue
                        
                        let date = animalInfo["EventDate"]as?String
                        
                        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lgt)
                        
                        let animal = AnimalInformation(
                            title:name!,
                            eventDate:date!,
                            coordinate: coordinate)
                        self.animalInfomations?.addObject(animal)
                    }
                    
                    self.classifyDataByLocation(self.animalInfomations!)
                    self.addAnnotations(self.classifiedData,coordinate: coordinate)
                    
                }
                
            }
            catch let error as NSError {
                print("error")
                print(error.localizedDescription)
              //  self.alertDelegate?.showAlert()
            }
            
        })
        
        
        task.resume()
        
    }
    
    //The structure of classified data is 
    //that the same animals are put in the same array
    func classifyDataByLocation(animalInformations:NSMutableArray)
    {
        
        
        for item in animalInformations
        {
            let tmpItem = item as! AnimalInformation
            
            if classifiedData.count == 0
            {
                let newArray : NSMutableArray = [item]
                classifiedData[0] = newArray
            }
            else
            {
                //compare item's coordinate with every
                var findSameLocation : Bool = false
                for (number, animalInfoArray) in classifiedData
                {
                    //compare item's coordinate with coordinate in dictionary
                    //if they are the same, then add item to the array
                    
                    let tmpAnimal = animalInfoArray[0]as! AnimalInformation
                    
                    if tmpItem.coordinate?.latitude == tmpAnimal.coordinate!.latitude && tmpItem.coordinate?.longitude == tmpAnimal.coordinate!.longitude
                    {
                        animalInfoArray.addObject(tmpItem)
                        classifiedData.updateValue(animalInfoArray, forKey: number)
                        findSameLocation = true
                        break
                    }
                }
                
                //if they are not the same, then new an array and add the array to dictionary
                if findSameLocation == false
                {
                    let newAnimalInfoArray  = NSMutableArray()
                    newAnimalInfoArray.addObject(tmpItem)
                    let key = classifiedData.count
                    classifiedData[key] = newAnimalInfoArray
                }
                
            }
          }
        
    }
    
    
    func addAnnotations(classifiedData:[Int:NSMutableArray],coordinate:CLLocationCoordinate2D)
    {
        var annotationView:MKPinAnnotationView!
        var pointAnnoation:CustomPointAnnotation!
     
        
        //covert animalInformations to annotations
        
        for (_,animalArray) in classifiedData
        {
            let animal = animalArray[0]as! AnimalInformation
            
            pointAnnoation = CustomPointAnnotation()
            
            pointAnnoation.pinCustomImageName = "AnimalSign"
            
            pointAnnoation.animalInfoArray = animalArray
            
            pointAnnoation.coordinate = animal.coordinate!
            
            //Title of annotation
            if (animalArray.count == 1)
            {
                pointAnnoation.title = "\(animalArray.count)   record."

            }else{
                pointAnnoation.title = "\(animalArray.count)   records."
            }
            
            //calculate distance between current loc and animal loc
            let distance = calculateDistanceInKM(currentLoc!,secondLocation: animal.coordinate!)
            //Subtitle of annotation
            pointAnnoation.subtitle =  "\(distance) km from current location"
            
            annotationView = MKPinAnnotationView(annotation: pointAnnoation, reuseIdentifier: "pin")
            
            //Add annotations to map
            self.Map!.addAnnotation(annotationView.annotation!)
            
            //
            //            let animalMKAnnotation = DangerousAnimalLocation(title: animal.title!,subtitle: animal.eventDate!,coordinate: animal.coordinate!)
            //
            //            animalMKAnnotations.append(animalMKAnnotation)
        }
        
        //Add annotations to map
        //        Map.addAnnotations(animalMKAnnotations)
        let span = MKCoordinateSpanMake(0.5, 0.5)
        let region = MKCoordinateRegionMake(coordinate, span)
        
        //modify UI on the main thread
        dispatch_async(dispatch_get_main_queue()) {
            self.Map!.setRegion(region, animated: false)
       }

        
        
    }
    
    func calculateDistanceInKM(firstLocation:CLLocationCoordinate2D,secondLocation:CLLocationCoordinate2D) -> Double{
        
        let fisrtLoc = CLLocation(latitude: firstLocation.latitude,longitude: firstLocation.longitude)
        let secondLoc = CLLocation(latitude: secondLocation.latitude,longitude: secondLocation.longitude)
        
        //one decimal for double
        let x = fisrtLoc.distanceFromLocation(secondLoc)/1000
        let y = Double(round(10*x)/10)
        return y
        
    }
    
    
    func converTimePara(time: String) -> String
    {
        var timePara: String?
        if(time == "all")
        {
            timePara = "all"
        }
        else
        {
            let date = NSDate()
            let calendar = NSCalendar.currentCalendar()
            let components = calendar.components([.Day , .Month , .Year], fromDate: date)
            
            let year =  components.year
//            let month = components.month
//            let day = components.day
            timePara = "\(year) - 2"
        }
        return timePara!
    }
}


    

