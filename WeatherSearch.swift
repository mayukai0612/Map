//
//  WeatherSearch.swift
//  Map
//
//  Created by Yukai Ma on 31/08/2016.
//  Copyright © 2016 Yukai Ma. All rights reserved.
//

import UIKit
import MapKit
protocol addWeatherDelegate{
    func addWeather(coordinate:CLLocationCoordinate2D)

}
class WeatherSearch: UIViewController,UITableViewDelegate,UISearchBarDelegate,UITableViewDataSource  {
    
    
    @IBOutlet weak var weatherSearchBar: UISearchBar!

    @IBOutlet weak var tableView: UITableView!
    
    var matchingItems:[MKMapItem] = []
    //   var selectedLocation: String?
    var mapView: MKMapView?
    
    var selectedLocation: CLLocationCoordinate2D?
    var delegate:addWeatherDelegate?
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
     //   self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)

        self.mapView = MKMapView()
        self.tableView.delegate  = self
        self.tableView.dataSource = self
        self.tableView!.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        self.weatherSearchBar.delegate = self
        self.showAnimate()
   
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
  
    
    
    
  
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
        self.view.alpha = 0.0;
        UIView.animateWithDuration(0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animateWithDuration(0.25, animations: {
            self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
            self.view.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished)
                {
                    self.view.removeFromSuperview()
                }
        });
    }
    
    
  
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
        
        let selectedItem = matchingItems[indexPath.row].placemark
        cell.textLabel?.text = selectedItem.name
        cell.detailTextLabel?.text = parseAddress(selectedItem)
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //    var count:Int?
        
        return matchingItems.count
        
        
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
        
        let selectedItem = matchingItems[indexPath.row].placemark
        self.weatherSearchBar?.text = self.parseAddress(selectedItem)
        self.selectedLocation = selectedItem.coordinate
       
    }
    
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        
        self.tableView?.reloadData()
    }
    
    // This method updates filteredData based on the text in the Search Box
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard let mapView = self.mapView,
            let searchBarText = self.weatherSearchBar!.text else { return }
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchBarText
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
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        if(self.selectedLocation == nil)
        {
            //alert
            let alertController = UIAlertController(title: "iOScreator", message: "Please select the location from the list  !", preferredStyle: UIAlertControllerStyle.Alert)
            
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            return
            
        }else{
        self.navigationController?.popViewControllerAnimated(true)
           delegate?.addWeather(self.selectedLocation!)
        }
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
        
        
        self.tableView!.reloadData()
        
        return true
        
    }
    
 
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}
