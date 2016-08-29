//
//  LocationPopUpView.swift
//  Map
//
//  Created by Yukai Ma on 28/08/2016.
//  Copyright © 2016 Yukai Ma. All rights reserved.
//

import UIKit
import MapKit

class LocationPopUpView: UIViewController,UITableViewDelegate,UISearchBarDelegate,UITableViewDataSource {
    
    
    @IBOutlet weak var displayedView: UIView!
  
    @IBOutlet weak var closeBtn: UIImageView!
    
    @IBOutlet weak var locationSearchBar: UISearchBar!
    
    @IBOutlet weak var tableView: UITableView!
    var matchingItems:[MKMapItem] = []
    var selectedLocation: String?
    var mapView: MKMapView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
        
        self.displayedView.layer.cornerRadius = 5
        self.displayedView.layer.masksToBounds = true
        addActionOnCloseBtn()
        self.tableView.delegate  = self
        self.tableView.dataSource = self
        self.locationSearchBar.delegate = self
        self.showAnimate()
        self.mapView = MKMapView(frame:UIScreen.mainScreen().bounds)

        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //    @IBAction func ClosePopUpWindow(sender: AnyObject) {
    //        self.removeAnimate()
    //        //self.view.removeFromSuperview()
    //    }
    //
    
    @IBAction func ClosePopUp(sender: AnyObject) {
        self.view.removeFromSuperview()
        
    }
    
    @IBAction func doneBtnAction(sender: AnyObject) {
        
        self.view.removeFromSuperview()

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
    func  addActionOnCloseBtn() {
        let singleTap = UITapGestureRecognizer(target: self, action:(#selector(CategoryPopupView.tapDetected)))
        singleTap.numberOfTapsRequired = 1
        closeBtn.userInteractionEnabled = true
        closeBtn.addGestureRecognizer(singleTap)
        
    }
    
    func tapDetected()
    {
        self.view.removeFromSuperview()
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableCell")! as UITableViewCell
       
            let selectedItem = matchingItems[indexPath.row].placemark
            cell.textLabel?.text = selectedItem.name
            cell.detailTextLabel?.text = parseAddress(selectedItem)
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //    var count:Int?
        
        guard let count:Int =  matchingItems.count
                else{
                    return 0
        }
    
        
        return count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
       
       
            let selectedItem = matchingItems[indexPath.row].placemark
            self.locationSearchBar?.text = self.parseAddress(selectedItem)
          //  self.selectedLocation = selectedItem.coordinate
            print(self.parseAddress(selectedItem))
        
        
    }
    
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
       
        self.tableView?.reloadData()
    }
    
    // This method updates filteredData based on the text in the Search Box
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
            guard let mapView = self.mapView,
                let searchBarText = self.locationSearchBar!.text else { return }
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

    
}
