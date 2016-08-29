//
//  JournalList.swift
//  Map
//
//  Created by Yukai Ma on 26/08/2016.
//  Copyright © 2016 Yukai Ma. All rights reserved.
//

import UIKit

class JournalList: UIViewController,UITableViewDelegate,UITableViewDataSource{

    @IBOutlet weak var tripTableView: UITableView!
    
    var tripList:NSMutableArray? = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let trip  = Trip(departTime:"2016-8-20",whatsAbout:"Plant Collection",tripLoc:"Clayton")
        tripList?.addObject(trip)
        tripTableView.delegate = self
        tripTableView.dataSource = self
        tripTableView.tableFooterView = UIView()

//         self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default)
//        // Sets shadow (line below the bar) to a blank image
//         self.navigationController?.navigationBar.shadowImage = UIImage()
//        // Sets the translucent background color
//         self.navigationController?.navigationBar.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
        self.navigationController?.navigationBar.translucent = true

        let navBarColor = UIColor(red: 55, green: 155, blue: 50)
        self.navigationController?.navigationBar.backgroundColor = navBarColor
        self.navigationController?.navigationBar.tintColor = navBarColor


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
        
        let trip: Trip = self.tripList![indexPath.row] as! Trip
        cell.tripCategory?.image = UIImage(named: "Car")
            cell.tripTitleLable?.text =  trip.whatsAbout
        cell.tripDate.text = trip.departTime
        cell.tripLocLable.text = trip.tripLoc
      
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return (tripList?.count)!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        
    }
    
    

    
}
