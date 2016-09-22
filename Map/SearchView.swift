//
//  SearchView.swift
//  Map
//
//  Created by Yukai Ma on 23/08/2016.
//  Copyright © 2016 Yukai Ma. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

protocol loadIconViewsDelegate {
    func loadIconViews()
}

protocol updateMapDelegate {
    func updateMap(animalPara:String, locPara:CLLocationCoordinate2D,distance:Int,time:String)
    func updateSelectedLoc(selectedLoc:CLLocationCoordinate2D)
    func updateSelectedAnimal(animal:String)

}

class SearchView: UIViewController,UITableViewDelegate,UISearchBarDelegate,UITableViewDataSource{
    
   
    
    let data =  ["Box jellyfish","Honey bee","Centipedes","Blue-ringed octopus",
        "Bull shark","Tiger shark","East brown snake","Melbourne Trap-door Spider","Redback spider","Geographer cone snail","Tick","White-tailed spiders","Bull ants","Blue bottle","Common Death Adder","Red-bellied Black Snake","Yellow-bellied Sea Snake","Highland Copperhead","European Wasp","Fox","Hog Deer","Red Deer","Fallow Deer","Dingo","Rabbit","Brush-tailed Rock-wallaby","Swamp Wallaby","Trichosurus caninus","Common Brushtail Possum","Wombat"]



    var animalSearchBar: UISearchBar?
    var locationSearchBar: UISearchBar?
    var tableView:UITableView?

    var selectedSearchBar: String?
    var selectedLocation: CLLocationCoordinate2D?
    var currentLocCoord: CLLocationCoordinate2D?
    
    var delegate: loadIconViewsDelegate?
    var updateMapViewDelegate: updateMapDelegate?

    var mapView: MKMapView? = nil
    

    var filteredData: [String]!
    var matchingItems:[MKMapItem] = []

    
    var distancePara: Int?
    var timePara: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        self.navigationItem.setHidesBackButton(true, animated: false)

        filteredData = data

        removeSubViewsFromNavBar()
        
        addSearchViews()
        
        self.selectedSearchBar = "animalSearch"
        //remove the space between tableview and edge
        self.automaticallyAdjustsScrollViewInsets = false;

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if(self.animalSearchBar != nil){
            self.animalSearchBar?.becomeFirstResponder()
        }
   
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func addSearchViews()
    {
    
        //add table view to main view
        let tableViewFrame = CGRect(x: 0, y: 110, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height - 340)
        
        self.tableView = UITableView(frame: tableViewFrame, style: UITableViewStyle.Plain)
        self.tableView!.delegate = self
        self.tableView!.dataSource = self
        self.tableView!.registerClass(UITableViewCell.self, forCellReuseIdentifier: "TableCell")
        tableView?.tag = 100
        self.view.addSubview(self.tableView!)
        
        //define subviews on navbar
        
        let navBar = self.navigationController?.navigationBar
        
        //cancle button frame
        let cancleButtonFrame = CGRect(x: 10, y: navBar!.frame.height/2 - 15, width: 30, height: 30)
        //animal search bar frame
        let animalSearchBarFrame = CGRect(x: 50 , y: 5, width:  navBar!.frame.width-60, height: 44)
        //location search bar frame
        let locationSearchBarFrame = CGRect(x: 50, y: 45, width: navBar!.frame.width-60, height: 44)
        
        
        
        //create animal search bar
        
        self.animalSearchBar = UISearchBar(frame: animalSearchBarFrame)
        self.animalSearchBar!.placeholder  = "Animal names                                                     "
        self.animalSearchBar!.delegate = self
        self.animalSearchBar?.accessibilityIdentifier = "animalSearch"
        
        //create location search bar
        
        self.locationSearchBar = UISearchBar(frame: locationSearchBarFrame)
        self.locationSearchBar!.placeholder  = "Current Location                                                "
        let locimage: UIImage = UIImage(named: "Ping")!
        self.locationSearchBar!.setImage(locimage, forSearchBarIcon: UISearchBarIcon.Search, state: UIControlState.Normal)
        self.locationSearchBar!.delegate = self
        self.locationSearchBar?.accessibilityIdentifier = "locationSearch"
        
        
        
        //create cancle button image
        let cancleButton = UIImageView(frame:cancleButtonFrame)
        cancleButton.contentMode = .ScaleAspectFit
        let image = UIImage(named: "Cross")
        cancleButton.image = image
        
        let singleTap = UITapGestureRecognizer(target: self, action:(#selector(SearchView.tapDetected)))
        singleTap.numberOfTapsRequired = 1
        cancleButton.userInteractionEnabled = true
        cancleButton.addGestureRecognizer(singleTap)
        
        
        //add views to navBar
        navBar!.addSubview(self.animalSearchBar!)
        navBar!.addSubview(self.locationSearchBar!)
        navBar!.addSubview(cancleButton)
        
        
    }
    
  
    func removeSubViewsFromNavBar()
    {
        for view in (self.navigationController?.navigationBar.subviews)! {
            if view != self.navigationItem.leftBarButtonItem{
                view.removeFromSuperview()
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableCell")! as UITableViewCell
        if(self.selectedSearchBar == "animalSearch")
        {
            if indexPath.row < filteredData.count{
                cell.textLabel?.text = filteredData[indexPath.row]
                print(indexPath.row)
            }
        }
        else if(self.selectedSearchBar == "locationSearch" )
        {
            let selectedItem = matchingItems[indexPath.row].placemark
            cell.textLabel?.text = selectedItem.name
            cell.detailTextLabel?.text = parseAddress(selectedItem)
        }
  
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count:Int?
        
        if(self.selectedSearchBar == "animalSearch" )
        {
            count =  filteredData.count
        }
        else if(self.selectedSearchBar == "locationSearch")
            
        {
            count =  matchingItems.count
        }
        else{ count = 0}
        
        return count!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if(self.selectedSearchBar == "animalSearch")
        {
            let selectedItem = filteredData[indexPath.row]
            self.animalSearchBar?.text = selectedItem
        }
            
        else if(self.selectedSearchBar == "locationSearch" )
        {
            let selectedItem = matchingItems[indexPath.row].placemark
            self.locationSearchBar?.text = self.parseAddress(selectedItem)
            self.selectedLocation = selectedItem.coordinate
            print(self.parseAddress(selectedItem))
        }
        
    }
    
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        if(selectedSearchBar == "animalSearch"){
            filteredData = self.animalSearchBar!.text!.isEmpty ? data : data.filter({(dataString: String) -> Bool in
                return dataString.rangeOfString((self.animalSearchBar?.text!)!, options: .CaseInsensitiveSearch) != nil
            })
        }
        self.tableView?.reloadData()
    }
    
    // This method updates filteredData based on the text in the Search Box
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if(self.selectedSearchBar == "animalSearch"){
            // When there is no text, filteredData is the same as the original data
            if searchText.isEmpty {
                filteredData = data
            } else {
                // The user has entered text into the search box
                // Use the filter method to iterate over all items in the data array
                // For each item, return true if the item should be included and false if the
                // item should NOT be included
                filteredData = data.filter({(dataItem: String) -> Bool in
                    // If dataItem matches the searchText, return true to include it
                    if dataItem.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil {
                        return true
                    } else {
                        return false
                    }
                })
            }
            self.tableView!.reloadData()
        }
        else if (self.selectedSearchBar == "locationSearch")
        {
            guard let mapView = mapView,
                let searchBarText = self.locationSearchBar!.text else { return }
            let request = MKLocalSearchRequest()
            request.naturalLanguageQuery = searchBarText + ",Australia"
            request.region = mapView.region
            let search = MKLocalSearch(request: request)
            search.startWithCompletionHandler { response, _ in
                guard let response = response else {
                    return
                }

                self.matchingItems = response.mapItems
                self.tableView!.reloadData()
            }
        }
    }
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        var animalPara: String?
        var locPara: CLLocationCoordinate2D?

        //if the user does not input animal
        if(self.animalSearchBar?.text == "")
        {
            animalPara = "all"
        }
        else{
            animalPara = (self.animalSearchBar?.text)!
            updateMapViewDelegate?.updateSelectedAnimal(animalPara!)
        }
        
        //if the user does not input location
        if(self.locationSearchBar?.text == "")
        {
            locPara = self.currentLocCoord
        }
        else if(self.selectedLocation == nil)
        {
            //alert
            let alertController = UIAlertController(title: "iOScreator", message: "Please select the location from the list  !", preferredStyle: UIAlertControllerStyle.Alert)
            
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            return

        }
            
        else{
            updateMapViewDelegate?.updateSelectedLoc(selectedLocation!)
            locPara = self.selectedLocation
        }
        
        //here the distance and time parameter will not be used, so just give them values
        updateMapViewDelegate?.updateMap(animalPara!,locPara: locPara!,distance: self.distancePara!,time: self.timePara!)
        
        removeSubViewsFromNavBar()
        navigationController!.popViewControllerAnimated(true)
        delegate!.loadIconViews()
        
      
    }
    
    //parse address to string
    func parseAddress(selectedItem:MKPlacemark) -> String {
        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        // put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        return addressLine
    }
    
    //UISearch bar delegate to make search bar unediteable
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar)-> Bool
    {
        
        self.selectedSearchBar = searchBar.accessibilityIdentifier
        
        self.tableView!.reloadData()
       
        return true
        
    }
    
   
    func tapDetected() {
        removeSubViewsFromNavBar()
        navigationController!.popViewControllerAnimated(true)
        delegate!.loadIconViews()
    }
}
