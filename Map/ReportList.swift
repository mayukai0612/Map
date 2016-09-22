//
//  ReportList.swift
//  Map
//
//  Created by Yukai Ma on 18/09/2016.
//  Copyright © 2016 Yukai Ma. All rights reserved.
//

import UIKit

class ReportList: UIViewController,UITableViewDelegate,UITableViewDataSource,UIPickerViewDelegate,UIPickerViewDataSource,RefreshDelegate,UITextFieldDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var categoryTextField: UITextField!
    
    
    @IBOutlet weak var timeTextfield: UITextField!
    
    @IBOutlet weak var reportDangerImage: UIImageView!
    
    @IBOutlet weak var wildAnimalControlImage: UIImageView!
    
    @IBAction func reportAction(sender: AnyObject) {
        //navigate to add report view controller
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("addReport") as! AddReport
        self.navigationController?.pushViewController(vc, animated: true)
    
    }
    
    var syncCompleted:Bool=false
    var reportList:NSMutableArray = []
    
    var tmpList:NSMutableArray = []

    var categorySet:NSArray = ["All categories","Animals",
                             "Weather",
                             "Fire",
                             "Flood",
                             "RoadConditions",
                             "WildThreat",
                             "Other"]
    var timeSet = ["Time ascending","Time descending"]

    var categoryPicker = UIPickerView()
    var timePicker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        
        categoryTextField.text = "All categories"
        timeTextfield.text = "Time descending"
        
        categoryPicker.tag  = 1
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        
        categoryTextField.inputView = categoryPicker
        categoryTextField.delegate = self
        categoryTextField.tag = 1
        
        timePicker.tag  = 2
        timePicker.delegate = self
        timePicker.dataSource = self
        
        timeTextfield.inputView = timePicker
        timeTextfield.delegate = self
        timeTextfield.tag = 2
        
        
         addDoneToPicker()
        
        addActionsToImage()
        
        //remove the blank area on the top of tableview
        self.automaticallyAdjustsScrollViewInsets = false
        
        
        tableView.delegate  = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 90

        //right bar item
        let reloadItem = UIBarButtonItem(title: "Refresh", style: .Plain, target: self, action: #selector(refresh))

        self.navigationItem.rightBarButtonItem = reloadItem
      //  tableView.registerClass(ReportListCell.self, forCellReuseIdentifier: "reportCell")
        let reportDB = ReportDB()
        reportDB.downloadReportData(self.reportList,tmpList: self.tmpList,tableView:self.tableView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refresh()
    {   self.reportList.removeAllObjects()
        self.tmpList.removeAllObjects()
        let reportDB = ReportDB()
        reportDB.downloadReportData(self.reportList,tmpList:self.tmpList,tableView:self.tableView)
    }
    
    func addDoneToPicker()
    {
    
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.Default
        toolBar.translucent = true
        toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.sizeToFit()
        
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(ReportList.donePicker))
        
        toolBar.setItems([ spaceButton,cancelButton], animated: false)
        toolBar.userInteractionEnabled = true
        
        categoryTextField.inputAccessoryView = toolBar
        timeTextfield.inputAccessoryView = toolBar
    }
    
    func donePicker(){
        self.categoryTextField.resignFirstResponder()
        self.timeTextfield.resignFirstResponder()

    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    // returns the # of rows in each component..
     func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        var count:Int?
        
        if(pickerView.tag == 1){
           count = categorySet.count
        }
        
        if(pickerView.tag == 2){
            count = timeSet.count
        }
        
        return count!
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if(pickerView.tag == 1){
            categoryTextField.text = categorySet[row] as? String
        }
        
        if(pickerView.tag == 2){
            timeTextfield.text = timeSet[row] 
        }

        
    }
    
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        var title:String?
        
        if(pickerView.tag == 1){
            title =  categorySet[row] as? String
        }
        
        if(pickerView.tag == 2 ){
            title =  timeSet[row]
        }
        return title!

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
        vc.refreshDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        if (textField.tag == 1)
        {
            print(textField.text)
            self.orderByCategory(textField.text!)
            print(1)
        }
        
        if (textField.tag == 2)
        {
            if(textField.text == "Time ascending"){
            self.orderByTimeAscending()
            }
            
            if(textField.text == "Time descending"){
                self.orderByTimeDescending()
            }
        }
        
    }
    func orderByCategory(category:String)
    {
        switch category {
        case "All categories":
            self.refresh()
        case "Animals":
            showBasedOnCategory("Animals")
        case "Weather":
            showBasedOnCategory("Weather")
        case "Fire":
            showBasedOnCategory("Fire")
        case "Flood":
            showBasedOnCategory("Flood")
        case "RoadConditions":
            showBasedOnCategory("RoadConditions")
        case "WildThreat":
            showBasedOnCategory("WildThreat")
        case "Other":
            showBasedOnCategory("Other")
        default:
            self.refresh()
        }
 
    }
    
    func showBasedOnCategory(category:String)
    {
        
        self.reportList.removeAllObjects()
        for item in self.tmpList{
            self.reportList.addObject(item)
        }
        
       // self.reportList.removeAllObjects()
        for element in self.tmpList
        {
          
                if let item = element as? Report
                {
                    print("test")
                    let cat = item.reportCategory
                    print (cat)
                    if (cat != category)
                    {
                        
                        self.reportList.removeObject(element)
                    }

            }
           
            
    
 
        }
        
        self.tableView.reloadData()
    }
    
    
    func orderByTimeAscending()
    {
        
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        
        for element in self.reportList
        {
            
            if let item = element as? Report
            {
                let date = dateFormatter.dateFromString(item.reportTime!)
                
                item.compareDate = date
                
                self.reportList.removeObject(element)
                self.reportList.addObject(item)
                
            }
        }
        
     let result =    self.reportList.sort {
            $0.compareDate!!.compare($1.compareDate!!) == NSComparisonResult.OrderedAscending
        }
        
        reportList.removeAllObjects()
            for v in result
            {
                self.reportList.addObject(v)
            }
        self.tableView.reloadData()
        
        
    }
    
    func orderByTimeDescending()
    {
        
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        
        for element in self.reportList
        {
            
            if let item = element as? Report
            {
                let date = dateFormatter.dateFromString(item.reportTime!)
                
                item.compareDate = date
                
                self.reportList.removeObject(element)
                self.reportList.addObject(item)
                
            }
        }
        
        
        let result =    self.reportList.sort {
            $0.compareDate!!.compare($1.compareDate!!) == NSComparisonResult.OrderedDescending
        }
        
        reportList.removeAllObjects()
        for v in result
        {
            self.reportList.addObject(v)
        }
        self.tableView.reloadData()

    }
    
    
    
    func wildAnimalControl()
    {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("wildControl")
        self.navigationController?.pushViewController(vc!, animated: true)
        
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
