//
//  animalListForLocationsView.swift
//  Map
//
//  Created by Yukai Ma on 24/08/2016.
//  Copyright © 2016 Yukai Ma. All rights reserved.
//

import UIKit

class animalListForLocationsView: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    var delegate:loadIconViewsDelegate?
    var tableView:UITableView?
    var backButton:UIButton?
    var animalInfoArray: NSMutableArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            title.text = "Wild Danger"
            title.font = UIFont (name: "AmericanTypewriter-Bold", size: 15)
            title.textColor = UIColor.whiteColor()
        
            //crearte image view
            let imageView = UIImageView(frame: imageFrame)
            imageView.contentMode = .ScaleAspectFit
            let image = UIImage(named: "Logo")
            imageView.image = image
        
            //add views to navBar
            navBar!.addSubview(title)
            navBar!.addSubview(imageView)
        
            //add table view to main view
            let tableViewFrame = CGRect(x: 0, y: 110, width: UIScreen.mainScreen().bounds.width, height: UIScreen.mainScreen().bounds.height - 110)
        
        
            tableView = UITableView(frame: tableViewFrame, style: UITableViewStyle.Plain)
         //tableView!.contentInset = UIEdgeInsetsMake(-50, 0, -50, 0);

            tableView!.delegate = self
            tableView!.dataSource = self
            tableView!.registerClass(UITableViewCell.self, forCellReuseIdentifier: "TableCell")

            self.view.addSubview(self.tableView!)
        
        
        self.tableView?.reloadData()

    
    
    }
    
    func buttonClicked(sender: AnyObject?) {
        
        
        removeSubViewsFromNavBar()
        navigationController!.popViewControllerAnimated(true)
        delegate!.loadIconViews()
      
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TableCell")! as UITableViewCell
     
            let animal: AnimalInformation = self.animalInfoArray![indexPath.row] as! AnimalInformation
            cell.textLabel?.text = animal.title
            cell.detailTextLabel?.text =  animal.eventDate
    
        return cell
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return (animalInfoArray?.count)!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)

         let animal: AnimalInformation = self.animalInfoArray![indexPath.row] as! AnimalInformation
        
        let animalName = animal.title
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("animalProfile") as! AnimalProfile
        vc.animalName = animalName
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
//    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 0.1
//    }
}
