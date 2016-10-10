//
//  animalListForLocationsView.swift
//  Map
//
//  Created by Yukai Ma on 24/08/2016.
//  Copyright © 2016 Yukai Ma. All rights reserved.
//

import UIKit

class animalListForLocationsView: UIViewController,UITableViewDelegate,UITableViewDataSource,LoadNavBarViewsDelegate{
    
    var delegate:loadIconViewsDelegate?
    var tableView:UITableView?
    var backButton:UIButton?
    var animalInfoArray: NSMutableArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //disable the swipe back function
        self.navigationItem.setHidesBackButton(true, animated: false)
        removeSubViewsFromNavBar()
        addListViews()
        //remove the blank area on the top of tableview
        self.automaticallyAdjustsScrollViewInsets = false
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
     
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func removeSubViewsFromNavBar()
    {
        for view in (self.navigationController?.navigationBar.subviews)! {
            if view != self.navigationItem.leftBarButtonItem{
                view.removeFromSuperview()
            }
        }
    }
    
    func addListViews()
    {
//        // add back button
//        backButton = UIButton()
//        backButton!.frame = CGRectMake(10, 30, 30, 30)
//        //backButton?.backgroundColor = UIColor(red: 51, green: 170, blue: 255)
//        backButton?.setImage(UIImage(named: "Back"), forState: .Normal)
//        backButton!.addTarget(self, action:  #selector(buttonClicked), forControlEvents: .TouchUpInside)
//        self.navigationController?.navigationBar.addSubview(backButton!)
//        
//        //define subviews on navbar
//        let navBar = self.navigationController?.navigationBar
//            //logo frame
//            let imageFrame = CGRect(x: navBar!.frame.width/2 - 75, y: 30, width: 30, height: 30)
//            //title frame
//            let titleFrame = CGRect(x: navBar!.frame.width/2 - 35, y: 30, width: 100, height: 40)
//        
//            //create title
//            let title = UILabel(frame:titleFrame)
//            title.text = "Wild Danger"
//            title.font = UIFont (name: "AmericanTypewriter-Bold", size: 15)
//            title.textColor = UIColor.whiteColor()
//        
//            //crearte image view
//            let imageView = UIImageView(frame: imageFrame)
//            imageView.contentMode = .ScaleAspectFit
//            let image = UIImage(named: "Logo")
//            imageView.image = image
//        
//            //add views to navBar
//            navBar!.addSubview(title)
//            navBar!.addSubview(imageView)
//        
            loadNavBarviews()
            //add table view to main view
            let tableViewFrame = CGRect(x: 0, y: 110, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height - 110)
        
        
            tableView = UITableView(frame: tableViewFrame, style: UITableViewStyle.Plain)
         //tableView!.contentInset = UIEdgeInsetsMake(-50, 0, -50, 0);

            tableView!.delegate = self
            tableView!.dataSource = self
            tableView!.registerClass(AnimalInfoCell.self, forCellReuseIdentifier: NSStringFromClass(AnimalInfoCell))
        tableView!.rowHeight = 80
        //tableView!.estimatedRowHeight = 50

            self.view.addSubview(self.tableView!)
        
        
        self.tableView?.reloadData()

    
    
    }
    
    func buttonClicked(sender: AnyObject?) {
        
        
        removeSubViewsFromNavBar()
        navigationController!.popViewControllerAnimated(true)
        delegate!.loadIconViews()
      
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(AnimalInfoCell)) as! AnimalInfoCell
     
            let animal: AnimalInformation = self.animalInfoArray![indexPath.row] as! AnimalInformation
        
        cell.nameLabel.text = animal.title
        cell.dateLabel.text = animal.eventDate
        let risk = getRiskType(animal.title!)
        switch risk {
        case "Swim risk":
            cell.riskImageView.image = UIImage(named:"swimmingrisk")
            cell.hintLabel.text = " Swim risk"
        case "Drive risk":
            cell.riskImageView.image = UIImage(named:"drivingrisk")
            cell.hintLabel.text = " Drive risk"
        case "Walking risk":
            cell.riskImageView.image = UIImage(named:"walkingrisk")
            cell.hintLabel.text = " Walk risk"
        case "Wild life threat":
            cell.riskImageView.image = UIImage(named:"WildLifeThreat")
            cell.hintLabel.text = "Wild life threat"
        default:
            cell.riskImageView.image = UIImage(named:"WildLifeThreat")
            cell.hintLabel.text = "Wild life threat"
        }
        //cell.riskImageView.image = UIImage(named:"swimmingrisk")
        //cell.hintLabel.text = "Swim risk"
//            cell.textLabel?.text = animal.title
//            cell.detailTextLabel?.text =  animal.eventDate
//        
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return (animalInfoArray?.count)!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)

         let animal: AnimalInformation = self.animalInfoArray![indexPath.row] as! AnimalInformation
        
        var animalName:String?
        if(animal.title == "Southern Blue-ringed Octopus")
        {
             animalName = "Blue-ringed octopus"
        }
        else{
         animalName = animal.title
        }
        
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("animalProfile") as! AnimalProfile
        vc.animalName = animalName
        vc.loadNavBarViewsDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func loadNavBarviews ()
    {
        // add back button
        backButton = UIButton()
        backButton!.frame = CGRectMake(10, 30, 30, 30)
        //backButton?.backgroundColor = UIColor(red: 51, green: 170, blue: 255)
        backButton?.setImage(UIImage(named: "Back"), forState: .Normal)
        backButton!.addTarget(self, action:  #selector(buttonClicked), forControlEvents: .TouchUpInside)
        self.navigationController?.navigationBar.addSubview(backButton!)
        
        //define subviews on navbar
        let navBar = self.navigationController?.navigationBar
        //logo frame
        let imageFrame = CGRect(x: navBar!.frame.width/2 - 75, y: 30, width: 30, height: 30)
        //title frame
        let titleFrame = CGRect(x: navBar!.frame.width/2 - 35, y: 30, width: 100, height: 40)
        
        //create title
        let title = UILabel(frame:titleFrame)
        title.text = "Animal List"
        title.font = UIFont (name: "Arial-BoldMT", size: 15)
        title.textColor = UIColor.whiteColor()
        
        //crearte image view
        let imageView = UIImageView(frame: imageFrame)
        imageView.contentMode = .ScaleAspectFit
        let image = UIImage(named: "BearFootprintWhite")
        imageView.image = image
        
        //add views to navBar
        navBar!.addSubview(title)
        navBar!.addSubview(imageView)

    }
    
    func getRiskType(animalName:String) -> String
    {
        var riskType:String?
        
        riskType  = "risk"
        
        print(animalName)
        
        if(animalName == "Blue bottle" || animalName == "Southern Blue-ringed Octopus" || animalName == "Box jellyfish" || animalName == "Bull shark" || animalName == "Geographer cone snail" || animalName == "Tiger shark" || animalName == "Yellow-bellied Sea Snake")
        {
            riskType = "Swim risk"
        }
        
        if(animalName == "Brush-tailed Rock-wallaby" || animalName == "Common Brushtail Possum" || animalName == "Fallow Deer" || animalName == "Hog Deer" || animalName == "European Rabbit" || animalName == "Red Deer" || animalName == "Swamp Wallaby" || animalName == "Trichosurus caninus" || animalName == "Wombat")
        {
            riskType = "Drive risk"
        }
        
        
        if(animalName == "Bull ants" || animalName == "Centipedes" || animalName == "Common Death Adder" || animalName == "East brown snake" || animalName == "European Wasp" || animalName == "Highland Copperhead" || animalName == "Honey Bee" || animalName == "Melbourne Trap-door Spider" || animalName == "Red-bellied Black Snake" || animalName == "Redback spider" || animalName == "Tick" || animalName == "Tiger snake" || animalName == "White-tailed spiders")
        {
            riskType = "Walking risk"
        }
        
        if(animalName == "Dingo" || animalName == "Fox" )
        {
            riskType = "Wild life threat"
        }
        
        return riskType!
    }

}
