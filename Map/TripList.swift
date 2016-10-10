//
//  JournalList.swift
//  Map
//
//  Created by Yukai Ma on 26/08/2016.
//  Copyright © 2016 Yukai Ma. All rights reserved.
//

import UIKit

class TriplList: UIViewController,UITableViewDelegate,UITableViewDataSource,addTripsDelegate,reloadTableDelegate,PassFileNamesDelegate{

    @IBOutlet weak var tripTableView: UITableView!
    
    @IBOutlet weak var createTripImage: UIImageView!
    
    
//    @IBAction func addTripButton(sender: AnyObject) {
//
//        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("addTrip") as! AddTrip
//        vc.delegate = self
//        vc.editOrCreateFlag = "add"
//        vc.tripList = self.tripList
//       // vc.tripid = self.tripList.count + 1
//        self.navigationController!.pushViewController(vc, animated: true)
//
//        
//        
//    }
    
    var tripList = [Trip]()
    var userid:String?
    var selectedTrip: Trip?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tripTableView.delegate = self
        tripTableView.dataSource = self
        tripTableView.tableFooterView = UIView()
        tripTableView.rowHeight = 90

      
        
//         self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
//        // Sets shadow (line below the bar) to a blank image
//         self.navigationController?.navigationBar.shadowImage = UIImage()
//        // Sets the translucent background color
//         self.navigationController?.navigationBar.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
       // self.navigationController?.navigationBar.translucent = true
       // let navBarColor = UIColor(red: 55, green: 155, blue: 50)
       // self.navigationController?.navigationBar.backgroundColor = navBarColor
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        //get userid
        userid = NSUserDefaults.standardUserDefaults().stringForKey("userid")

        
        //load data
        
        let loadTrips = TripDB()
        loadTrips.delegate = self
        loadTrips.loadTrips(userid!)
        
        //add action to image
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(TriplList.createTrip))
        createTripImage.userInteractionEnabled = true
        createTripImage.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("tripCell")! as! TripCell
        
        let trip: Trip = self.tripList[indexPath.row] as! Trip
       // cell.tripCategory?.image = UIImage(named: "Car")
        if(trip.category == "group")
        {
            cell.tripCategory?.image = UIImage(named: "Group")

        }
        if(trip.category == "personal")
        {
            cell.tripCategory?.image = UIImage(named: "Personal")

        }
        if(trip.category == "pathFinding")
        {
            cell.tripCategory?.image = UIImage(named: "Car")

        }
        cell.tripTitleLable?.text =  trip.tripTitle
        cell.tripDate.text = trip.departTime
    //    cell.tripLocLable.text = trip.lat
        
      
        
        return cell
        
    }
    
    func createTrip()
    {
    
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("addTrip") as! AddTrip
                vc.delegate = self
                vc.editOrCreateFlag = "add"
                vc.tripList = self.tripList
               // vc.tripid = self.tripList.count + 1
                self.navigationController!.pushViewController(vc, animated: true)
    
    }
    
    //passFileNamesDelegate
    func passFileNames(filename: [String]) {
        //pass the file names to tirp
        
        self.selectedTrip?.imagefilename = filename
        
        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
        let destination = storyboard.instantiateViewControllerWithIdentifier("addTrip") as! AddTrip
        destination.trip = selectedTrip
        destination.tripid = selectedTrip?.tripID
        destination.delegate = self
        destination.editOrCreateFlag = "edit"

        navigationController?.pushViewController(destination, animated: true)
    }
    
    
    func reloadtable(trip:Trip)
    {
//        //load trips
//        let loadTrips = TripDB()
//        loadTrips.delegate = self
//        loadTrips.loadJournal(self.userid!)
        
        var findSameTrip: Bool = false
        
        //check if the trip is used to update
        for i in 0 ..< self.tripList.count{
            if (self.tripList[i].tripID == trip.tripID)
            {
                self.tripList[i]  = trip
                findSameTrip = true
            }
            
        }
        
        //if the trip is not used to update, append to array
        if(findSameTrip == false){
            self.tripList.append(trip)
        }
        
        self.tripTableView.reloadData()
    }
    
  
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (tripList.count)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
         selectedTrip = self.tripList[indexPath.row]
        
        //get fileNames of the selected trip
        let tripDB = TripDB()
        tripDB.passFileNamesDelegate = self
        tripDB.loadFileNames(selectedTrip!.userID!, tripid: Int(selectedTrip!.tripID!)!)
        
        //when a cell selected, it turns grey.Using deselect to turn it back to normal
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
//        let storyboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
//        let destination = storyboard.instantiateViewControllerWithIdentifier("addTrip") as! AddTrip
//        destination.trip = selectedTrip
//        destination.delegate = self
//        destination.editOrCreateFlag = "edit"
//        
//        //when a cell selected, it turns grey.Using deselect to turn it back to normal
//        tableView.deselectRowAtIndexPath(indexPath, animated: true)
//
//        navigationController?.pushViewController(destination, animated: true)
      
    }
    
    
    
    // Override to support delete todolist from current list
     func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let tripDB = TripDB()
            let selectedTrip = self.tripList[indexPath.row]
            tripDB.deleteTrip(selectedTrip)
            self.tripList.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    
    func updateList(tripList:[Trip])
    {
        dispatch_async(dispatch_get_main_queue()) {
            self.tripList = tripList
            self.tripTableView.reloadData()
        }

     
    }
    
    func setBackButton()
    {
      //  self.navigationController!.navigationBar.topItem!.title = "Back"
        self.navigationItem.leftBarButtonItem?.title = "back"
    }
    
  
    
    

    
}
