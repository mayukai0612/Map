//
//  MapSearch.swift
//  Map
//
//  Created by Yukai Ma on 19/08/2016.
//  Copyright © 2016 Yukai Ma. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

   
class MapSearch: UIViewController, UISearchBarDelegate ,MKMapViewDelegate,CLLocationManagerDelegate,loadIconViewsDelegate,updateMapDelegate,AlertDelegate{
    
   
    
    var searchView: SearchView?
    
    var animalInfoArray: NSMutableArray?
    let locationManager = CLLocationManager()
    var mapView: MKMapView? = nil
    var firstLaunchFlag = 0
    
    var currentLocCoord: CLLocationCoordinate2D?
    var seletedLoc :CLLocationCoordinate2D?
    var distanceFilterPara: Int = 10
    var timeFilterPara: String = "all"
    var seletedAnimal:String = "all"
    
    override func viewDidLoad() {
        

        super.viewDidLoad()
        
        

        //add map view
        let mapViewFrame = CGRect(x: 0, y: 110, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height - 110)
        self.mapView = MKMapView(frame: mapViewFrame)
        self.mapView?.tag = 50
        self.view.addSubview(self.mapView!)
        
     
        //load first views
        loadFirstViews()
        
        //show current location
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // using only when application is in use
       // self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView!.showsUserLocation = true


      
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
    func loadIconViews()
    {
        
        //        define subviews on navbar
        
        let navBar = self.navigationController?.navigationBar
        //logo frame
        let imageFrame = CGRect(x: navBar!.frame.width/2 - 75, y: 10, width: 30, height: 30)
        //title frame
        let titleFrame = CGRect(x: navBar!.frame.width/2 - 35, y: 10, width: 100, height: 40)
        // search bar frame
        let searchBarFrame = CGRect(x: 10, y: 50, width: navBar!.frame.width-20, height: 44)
        //filter frame
        let filterFrame =  CGRect(x: navBar!.frame.width - 35, y: 10, width: 30, height: 30)
        
        //filter frame
      //  let currentLocationFrame =  CGRect(x: 10, y: 30, width: 30, height: 30)
        
        //create search bar
        let searchBar = UISearchBar(frame: searchBarFrame)
        
        searchBar.placeholder  = "Animal,places..                                                            "
        searchBar.delegate = self
        
        //create title
        let title = UILabel(frame:titleFrame)
        title.text = "Wild Danger"
        title.font = UIFont (name: "AmericanTypewriter-Bold", size: 15)
        title.textColor = UIColor.whiteColor()
        
        //crearte image view
        let imageView = UIImageView(frame: imageFrame)
        imageView.contentMode = .ScaleAspectFit
        let image = UIImage(named: "Logo")
        imageView.image = image
        
        //create filter view
        let filterIcon = UIImageView(frame: filterFrame)
        filterIcon.contentMode = .ScaleAspectFit
        let filter = UIImage(named: "Filter")
        filterIcon.image = filter
        
        let singleTap = UITapGestureRecognizer(target: self, action:(#selector(MapSearch.filter)))
        singleTap.numberOfTapsRequired = 1
        filterIcon.userInteractionEnabled = true
        filterIcon.addGestureRecognizer(singleTap)
        
        //crearte current location view
        let clv = UIImageView(frame: imageFrame)
        let clvImg = UIImage(named: "Ping")
        clv.image = image
        //self.view.addSubview(clv)
        
        
        //add views to navBar
        navBar!.addSubview(searchBar)
        navBar!.addSubview(imageView)
        navBar!.addSubview(title)
        navBar!.addSubview(filterIcon)
        
    }
    
    func loadFirstViews()
    {
//        //remove map view from view
//        if let viewWithTag = self.view.viewWithTag(50) {
//            viewWithTag.removeFromSuperview()
//        }
//
//        //add map view
//        let mapViewFrame = CGRect(x: 0, y: 110, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height - 110)
//        self.mapView = MKMapView(frame: mapViewFrame)
//        self.mapView!.tag = 10
//        self.view.addSubview(self.mapView!)
////
//        define navigation bar
        
        _ = UIApplication.sharedApplication().statusBarFrame.size.height
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        
        //clear all subviews from navBar
        for view in (self.navigationController?.navigationBar.subviews)! {
            UIView.animateWithDuration(1, animations: {
                view.alpha = 0
            }) { _ in
                view.removeFromSuperview()
            }
        }
        
        let navBarColor = UIColor(red: 86, green: 171, blue: 59)
        self.navigationController?.navigationBar.backgroundColor = navBarColor
        self.navigationController?.navigationBar.tintColor = navBarColor
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
//        define subviews on navbar
        
        let navBar = self.navigationController?.navigationBar
        //logo frame
        let imageFrame = CGRect(x: navBar!.frame.width/2 - 75, y: 10, width: 30, height: 30)
        //title frame
        let titleFrame = CGRect(x: navBar!.frame.width/2 - 35, y: 10, width: 100, height: 40)
        // search bar frame
        let searchBarFrame = CGRect(x: 10, y: 50, width: navBar!.frame.width-20, height: 44)
        //filter frame
        let filterFrame =  CGRect(x: navBar!.frame.width - 35, y: 10, width: 30, height: 30)
        
        //currentLoc frame
        let currentLocationFrame =  CGRect(x: 10, y: 30, width: 30, height: 30)
        
        //create search bar
        let searchBar = UISearchBar(frame: searchBarFrame)

        searchBar.placeholder  = "Animal,places..                                                            "
        searchBar.delegate = self
        
        //create title
        let title = UILabel(frame:titleFrame)
        title.text = "Wild Danger"
        title.font = UIFont (name: "AmericanTypewriter-Bold", size: 15)
        title.textColor = UIColor.whiteColor()
        
        //crearte image view
        let imageView = UIImageView(frame: imageFrame)
        imageView.contentMode = .ScaleAspectFit
        let image = UIImage(named: "Logo")
        imageView.image = image
        
        //create filter view
        let filterIcon = UIImageView(frame: filterFrame)
        filterIcon.contentMode = .ScaleAspectFit
        let filter = UIImage(named: "Filter")
        filterIcon.image = filter
        
        let singleTap = UITapGestureRecognizer(target: self, action:(#selector(MapSearch.filter)))
        singleTap.numberOfTapsRequired = 1
        filterIcon.userInteractionEnabled = true
        filterIcon.addGestureRecognizer(singleTap)
        
//        //crearte current location view
//        let clv = UIImageView(frame: imageFrame)
//        let clvImg = UIImage(named: "Ping")
//        clv.image = image
//        //self.view.addSubview(clv)


        //add views to navBar
        navBar!.addSubview(searchBar)
        navBar!.addSubview(imageView)
        navBar!.addSubview(title)
        navBar!.addSubview(filterIcon)
        
        
        //show current location
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // using only when application is in use
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        self.mapView!.showsUserLocation = true

        let searchFromDB: SearchFromDB = SearchFromDB()
        searchFromDB.Map = self.mapView
        searchFromDB.Map!.delegate = self

    }
    
    func filter()
    {
        let filterView = self.storyboard!.instantiateViewControllerWithIdentifier("filterView") as! FilterView
        filterView.loadIconViewsdelegate = self
        filterView.updateMapViewDelegate = self
        filterView.distancePara = self.distanceFilterPara
        filterView.timePara  = self.timeFilterPara 
        if(self.seletedLoc != nil)
        {
            filterView.locPara = self.seletedLoc
        }
        else
        {
            filterView.locPara = self.currentLocCoord
        }
        filterView.animalPara = self.seletedAnimal
       // filterView.
    //    searchView.mapView = self.mapView
      //  searchView.currentLocCoord = self.currentLocCoord
        self.navigationController!.pushViewController(filterView, animated: true)

    }
//    

    
    //UISearch bar delegate to make search bar unediteable
     func searchBarShouldBeginEditing(searchBar: UISearchBar)-> Bool
     {
    
        let searchView = self.storyboard!.instantiateViewControllerWithIdentifier("searchView") as! SearchView
        searchView.delegate = self
        searchView.updateMapViewDelegate = self
        searchView.mapView = self.mapView
        searchView.currentLocCoord = self.currentLocCoord
        searchView.distancePara = self.distanceFilterPara
        searchView.timePara = self.timeFilterPara
        self.navigationController!.pushViewController(searchView, animated: true)

        return true

    }
    
    func showAlert() {
        
        dispatch_async(dispatch_get_main_queue()) {

        let alertController = UIAlertController(title: "iOScreator", message:
            "No results matching!", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func updateMap(animalPara:String, locPara:CLLocationCoordinate2D,distance:Int, time: String){
        
        self.mapView!.removeAnnotations(self.mapView!.annotations)

        let searchFromDB: SearchFromDB = SearchFromDB()
        searchFromDB.Map = self.mapView
        searchFromDB.Map!.delegate = self
        searchFromDB.alertDelegate = self
        searchFromDB.currentLoc = self.currentLocCoord
        
        self.timeFilterPara = time
        self.distanceFilterPara = distance
        
        dispatch_async(dispatch_get_main_queue()) {
        
            searchFromDB.loadDataByLocation(animalPara,coordinate: locPara,distacnce: distance,time:time)
      
        }
    }
    
    func updateSelectedLoc(selectedLoc: CLLocationCoordinate2D)
    {
        self.seletedLoc = selectedLoc
    }
    
    func updateSelectedAnimal(animal:String)
    {
    
        self.seletedAnimal = animal
    }

    func mapView(mapView: MKMapView,
                 viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView?{
        
        
        let reuseIdentifier = "pin"
        
        
        //create a annotationn view using identifier
        var v = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseIdentifier)
        if v == nil {
            v = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
            v!.canShowCallout = true
        }
        else {
            v!.annotation = annotation
        }
        //set img for call out
        let btn = UIButton(type: .DetailDisclosure)
        v!.rightCalloutAccessoryView = btn
        
        if (annotation is MKUserLocation) {
            //user location
            return nil
        }else{
            //set image
        let customPointAnnotation = annotation as! CustomPointAnnotation
        v!.image = UIImage(named:customPointAnnotation.pinCustomImageName)
            
        return v
        }
        
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        let annotation = view.annotation as!CustomPointAnnotation
        self.animalInfoArray = annotation.animalInfoArray
        

        let animalListView = self.storyboard!.instantiateViewControllerWithIdentifier("animalListForLocationsView") as! animalListForLocationsView
        animalListView.animalInfoArray = self.animalInfoArray
       animalListView.delegate = self
        self.navigationController!.pushViewController(animalListView, animated: true)
        

    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        let center = CLLocationCoordinate2DMake(location!.coordinate.latitude,location!.coordinate.longitude)
        
        let region = MKCoordinateRegionMake(center, MKCoordinateSpanMake(0.5, 0.5))
        
        self.mapView!.setRegion(region, animated: false)
        
        self.locationManager.stopUpdatingLocation()
        
        
        currentLocCoord =  locations.last!.coordinate
        
        if(firstLaunchFlag == 0)
        {
            let searchFromDB: SearchFromDB = SearchFromDB()
            searchFromDB.Map = self.mapView
            searchFromDB.Map!.delegate = self
            if (currentLocCoord != nil) {
                searchFromDB.currentLoc = currentLocCoord
                searchFromDB.loadDataByLocation("all",coordinate: currentLocCoord!,distacnce: self.distanceFilterPara,time: self.timeFilterPara)
            }
            firstLaunchFlag += 1
        }

    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error" + error.localizedDescription)
    }



}



extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        let newRed = CGFloat(red)/255
        let newGreen = CGFloat(green)/255
        let newBlue = CGFloat(blue)/255
        
        self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
    }
}