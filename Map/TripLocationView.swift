//
//  TripLocationView.swift
//  Map
//
//  Created by Yukai Ma on 28/08/2016.
//  Copyright © 2016 Yukai Ma. All rights reserved.
//

import UIKit
import MapKit

class TripLocationView: UIView ,updateTripParameterDelegate,showLocationDelegate{
    var delegate: addChildViewDelegate?
    var passParaDelegate:passTripParaDelegate?

    var mapView: MKMapView?
    var lat:String?
    var lgt:String?
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("locationPopUp") as! LocationPopUpView
            popOverVC.mapView = self.mapView
            popOverVC.delegate = self
            
            popOverVC.showLocDelegate = self

            
            delegate?.addChildView(popOverVC,viewIdentifier: "tripLocation")
            
       }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        if let touch = touches.first {
//            let currentPoint = touch.locationInView(self)
//            // do something with your currentPoint
//        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        if let touch = touches.first {
//            let currentPoint = touch.locationInView(self)
//            // do something with your currentPoint
//        }
    }
    
    
    func loadViews()
    {
        
        let imageFrame = CGRect(x:0, y: 0 , width: 155, height: 100)
        //title frame
        let titleFrame = CGRect(x: 155/2 - 50, y: 50, width: 120, height: 40)
        
        //crearte image view
        let imageView = UIImageView(frame: imageFrame)
        imageView.contentMode = .ScaleAspectFit
        let image = UIImage(named: "Trip_map")
        imageView.image = image
        
        //create title
        let title = UILabel(frame:titleFrame)
        title.text = "Where do I go"
        title.font = UIFont (name: "AppleSDGothicNeo-SemiBold", size: 18)
        let textColor = UIColor(red: 89, green: 45, blue: 23)
        title.textColor = textColor
        //create mapview
        
        //initialized on the main thread
        dispatch_async(dispatch_get_main_queue()) {
            self.mapView = MKMapView(frame:self.frame)
            // if the trip has been set location, then show the map
            // else show the default image
            if(self.lat != "" && self.lat != nil){
                self.addSubview(self.mapView!)
            }else{
                self.addSubview(imageView)
                
            }
            self.addSubview(title)
            self.showLocation()
        
        }

        
        
    }
 
    func updateTrip(tripPara: String, paraIdentifier: String) {
        passParaDelegate?.passTripPara(tripPara,paraIdentifier: paraIdentifier)

    }
    
    func showLocation()
    {
        if (self.lat != nil && self.lgt != nil&&self.lat != "" && self.lgt != "") {
            
        
        let latitude = Double(self.lat!)
        let longitude = Double(self.lgt!)
        let theSpan:MKCoordinateSpan = MKCoordinateSpanMake(0.01 , 0.01)
        let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        let theRegion:MKCoordinateRegion = MKCoordinateRegionMake(location, theSpan)
        
        self.mapView!.setRegion(theRegion, animated: true)
        
        let anotation = MKPointAnnotation()
        anotation.coordinate = location
      //  anotation.title = "The Location"
        //anotation.subtitle = "This is the location !!!"
        self.mapView!.addAnnotation(anotation)
        
        }
        
    }
    
    func showLocationOnMap() {
            self.showLocation()
        
    }
    
    
}
