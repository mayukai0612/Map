//
//  ViewReport.swift
//  Map
//
//  Created by Yukai Ma on 19/09/2016.
//  Copyright © 2016 Yukai Ma. All rights reserved.
//

import UIKit

class ViewReport: UIViewController {
    
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var categoryImage: UIImageView!
    
    
    @IBOutlet weak var titleTextField: UITextField!
    
    
    @IBOutlet weak var lineBtwTitleAndContext: LineView!
    
    @IBOutlet weak var contentTextView: UITextView!
    
    
    
    @IBOutlet weak var lineBtwContextAndTime: LineView!
    
    
    @IBOutlet weak var timeView: UIView!
    
    
    @IBOutlet weak var locationView: UIView!
    
    
    @IBOutlet weak var timeLabel: UILabel!
    
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var lineBtwLocationAndImage: LineView!
    
    @IBOutlet weak var reportImageView: UIImageView!
    
    
    var report: Report?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //add dashed line
        lineBtwTitleAndContext.addDashedLine()
        lineBtwContextAndTime.addDashedLine()
        lineBtwLocationAndImage.addDashedLine()
        
        //
        addColorToViewBoard()
       
     
        //get rid of board of text field
        self.titleTextField.borderStyle = UITextBorderStyle.None
        self.titleTextField.layer.borderColor = UIColor.clearColor().CGColor
        self.titleTextField.userInteractionEnabled = false
        loadViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func addColorToViewBoard()
    {
        
       
        self.timeView.layer.borderWidth = 1
        self.timeView.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.locationView.layer.borderWidth = 1
        self.locationView.layer.borderColor = UIColor.lightGrayColor().CGColor
    }
   
    
    func loadViews()
    {
        if (self.report != nil){
        self.categoryImage.image = getCategoryImage((self.report?.reportCategory!)!)
        self.categoryLabel.text = self.report?.reportCategory
        self.titleTextField.text = self.report?.reportTitle
        self.contentTextView.text = self.report?.reportContent
        self.timeLabel.text = self.report?.reportTime
        self.locationLabel.text = self.report?.reportAddress
        
        let reportDB = ReportDB()
        let fileName = self.report!.imageFileName!
        print(fileName)
        //let url = NSURL(fileURLWithPath: "http://173.255.245.239/DangerousAnimals/Images/\(fileName)")
        let urlString = "http://173.255.245.239/DangerousAnimals/Images/"
        
            let NSHipster = NSURL(string: urlString)   //returns a valid URL
            
            //Returns valid NSHipster URL
            let url = NSURL(string: fileName, relativeToURL: NSHipster)
        reportDB.downLoadImageWithUrl(url!,imageView: self.reportImageView)
        }
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
