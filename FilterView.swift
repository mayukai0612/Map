//
//  FilterView.swift
//  Map
//
//  Created by Yukai Ma on 24/08/2016.
//  Copyright © 2016 Yukai Ma. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class FilterView: UIViewController {

    var loadIconViewsdelegate:loadIconViewsDelegate?

    var distancePara: Int?
    
    var timePara: String?
    
    var locPara: CLLocationCoordinate2D?
    
    var animalPara: String?
    
    var updateMapViewDelegate: updateMapDelegate?
    
    @IBOutlet weak var distanceFilter: UISegmentedControl!
    
    
    @IBOutlet weak var timeFilter: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        removeSubViewsFromNavBar()
        addViewsToNavBar()
        if(distancePara == 1)
        {
            distanceFilter.selectedSegmentIndex  = 0

        }
        if(distancePara == 5)
        {
            distanceFilter.selectedSegmentIndex  = 1

        }
        if(distancePara == 10)
        {
            distanceFilter.selectedSegmentIndex  = 2

        }
        
        if(timePara == "all"){
        timeFilter.selectedSegmentIndex = 1
        }
        else if (timePara == "3"){
            timeFilter.selectedSegmentIndex = 0

        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func changeDistanceFilter(sender: AnyObject) {
        
        if(distanceFilter.selectedSegmentIndex == 0)
        {
           distancePara  = 1
        }
        
        if(distanceFilter.selectedSegmentIndex == 1)
        {
            distancePara  = 5
        }
        
        if(distanceFilter.selectedSegmentIndex == 2)
        {
            distancePara  = 10
        }
        
        
    }
    
    
    @IBAction func changeTimeFilter(sender: AnyObject) {
        
        if(timeFilter.selectedSegmentIndex == 0)
        {
            timePara = "3"
        }
        
        if(timeFilter.selectedSegmentIndex == 1)
        {
            timePara = "all"
        }
     
        
    }
    
    
    func removeSubViewsFromNavBar()
    {
        for view in (self.navigationController?.navigationBar.subviews)! {
            if view != self.navigationItem.leftBarButtonItem{
                view.removeFromSuperview()
            }
        }
    }
    
    func addViewsToNavBar() {
        
        //define subviews on navbar
        let navBar = self.navigationController?.navigationBar
        //logo frame
        let imageFrame = CGRect(x: navBar!.frame.width/2 - 75, y: 30, width: 30, height: 30)
        //title frame
        let titleFrame = CGRect(x: navBar!.frame.width/2 - 35, y: 30, width: 100, height: 40)
        //Done frame
        let doneFrame = CGRect(x: navBar!.frame.width - 40, y:30 , width: 30, height: 30)
        //Cancle frame
        let cancleFrame = CGRect(x: 10, y: 30, width: 30, height: 30)
        
        
        //create title
        let title = UILabel(frame:titleFrame)
        title.text = "Wild Safety"
        title.font = UIFont (name: "Arial-BoldMT", size: 15)
        title.textColor = UIColor.whiteColor()
        
        //crearte image view
        let imageView = UIImageView(frame: imageFrame)
        imageView.contentMode = .ScaleAspectFit
        let image = UIImage(named: "BearFootprintWhite")
        imageView.image = image
        
        //create Done
        let doneView = UIImageView(frame: doneFrame)
        doneView.contentMode = .ScaleAspectFit
        let done = UIImage(named: "Done")
        doneView.image = done
        
        //create Cancle
        let cancleView = UIImageView(frame: cancleFrame)
        cancleView.contentMode = .ScaleAspectFit
        let cancle = UIImage(named: "Cancle")
        cancleView.image = cancle
        
        //add action to Done
        let singleTapOfDone = UITapGestureRecognizer(target: self, action:(#selector(FilterView.done)))
        singleTapOfDone.numberOfTapsRequired = 1
        doneView.userInteractionEnabled = true
        doneView.addGestureRecognizer(singleTapOfDone)
        
        
        //add action to cancle
        let singleTapOfCancle = UITapGestureRecognizer(target: self, action:(#selector(FilterView.cancle)))
        singleTapOfCancle.numberOfTapsRequired = 1
        cancleView.userInteractionEnabled = true
        cancleView.addGestureRecognizer(singleTapOfCancle)
        
        //add views to navBar
        navBar!.addSubview(title)
        navBar!.addSubview(imageView)
        navBar!.addSubview(cancleView)
        navBar!.addSubview(doneView)

        
    }
    
    func done()
    {
        updateMapViewDelegate?.updateMap(self.animalPara!, locPara:self.locPara!,distance:self.distancePara!,time:self.timePara!)
        removeSubViewsFromNavBar()
    
        self.navigationController?.popViewControllerAnimated(true)
        loadIconViewsdelegate?.loadIconViews()
        
    }
    
    
    func cancle()
    {
            removeSubViewsFromNavBar()
            self.navigationController?.popViewControllerAnimated(true)
            loadIconViewsdelegate?.loadIconViews()
    }
}
