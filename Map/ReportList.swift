//
//  ReportList.swift
//  Map
//
//  Created by Yukai Ma on 18/09/2016.
//  Copyright © 2016 Yukai Ma. All rights reserved.
//

import UIKit


class ReportList: UIViewController,UITableViewDelegate,UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var reportDangerImage: UIImageView!
    
    @IBOutlet weak var wildAnimalControlImage: UIImageView!
    
    @IBAction func reportAction(sender: AnyObject) {
        //navigate to add report view controller
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("addReport") as! AddReport
        self.navigationController?.pushViewController(vc, animated: true)
    
    }
    
    var syncCompleted:Bool=false
    var reportList:NSMutableArray = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addActionsToImage()
        
        //remove the blank area on the top of tableview
        self.automaticallyAdjustsScrollViewInsets = false
        
        
        tableView.delegate  = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 90

      //  tableView.registerClass(ReportListCell.self, forCellReuseIdentifier: "reportCell")
        let reportDB = ReportDB()
        reportDB.downloadReportData(self.reportList,tableView:self.tableView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addActionsToImage()
    {
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(ReportList.reportDanger))
        reportDangerImage.userInteractionEnabled = true
        reportDangerImage.addGestureRecognizer(tapGestureRecognizer)
        
        let aTapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(ReportList.wildAnimalControl))
        wildAnimalControlImage.userInteractionEnabled = true
        wildAnimalControlImage.addGestureRecognizer(aTapGestureRecognizer)
    
    }
    
    
    func reportDanger()
    {
        
        //navigate to add report view controller
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("addReport") as! AddReport
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
    func wildAnimalControl()
    {
        
        
    }
    
    //return number of sections
     func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    //return number of rows
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
            return self.reportList.count
    
    }
    
    
    
    //define the data of each cells
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //instantiate a reusable cell from a predefined cell class
        let cell = tableView.dequeueReusableCellWithIdentifier("reportCell", forIndexPath: indexPath) as? ReportListCell
        let report: Report = reportList[indexPath.row]as!Report
        cell!.reportTitle.text = report.reportTitle
        cell!.reportTime.text = report.reportTime
        cell!.reportLocation.text = report.reportAddress
        cell!.categoryImageView.image = getCategoryImage(report.reportCategory!)
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let report = self.reportList[indexPath.row] as! Report
        
      
        //when a cell selected, it turns grey.Using deselect to turn it back to normal
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
  
                let vc = self.storyboard!.instantiateViewControllerWithIdentifier("viewReport") as! ViewReport
                vc.report = report
        
        
                //when a cell selected, it turns grey.Using deselect to turn it back to normal
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
                self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    

   
    func getCategoryImage(category:String) -> UIImage
    {
        var image:UIImage?
        
        switch category {
        case "Animals":
            image = UIImage(named: "BearFootprint")
        case "Weather":
            image = UIImage(named: "WeatherForReport")
        case "Flood":
            image = UIImage(named: "Water")
        case "Fire":
            image = UIImage(named: "Fire")
        case "RoadConditions":
            image = UIImage(named: "Car")
        case "WildThreat":
            image = UIImage(named: "Wolf")
        case "Other":
            image = UIImage(named: "Others")
        default:
            image = UIImage(named: "QuestionMark")

        }
        
        return image!
    }
    

}
