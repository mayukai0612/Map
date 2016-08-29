//
//  TimePopUpView.swift
//  Map
//
//  Created by Yukai Ma on 28/08/2016.
//  Copyright © 2016 Yukai Ma. All rights reserved.
//

import UIKit

class TimePopUpView: UIViewController,UIActionSheetDelegate{

    @IBOutlet weak var departureTimeLable: UILabel!
    
    @IBOutlet weak var returnTimeLable: UILabel!
    
    @IBOutlet weak var closeBtn: UIImageView!

    @IBOutlet weak var displayedView: UIView!
    
    var datePicker: UIDatePicker?
    var selectedTimeLable: UILabel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
        
        self.displayedView.layer.cornerRadius = 5
        self.displayedView.layer.masksToBounds = true
        addActionOnCloseBtn()

        self.showAnimate()
        
        // Do any additional setup after loading the view.
        
        
        
        addActionToDepartDatePicker()
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
    
    
    @IBAction func donnBtnAction(sender: AnyObject) {
        
        self.view.removeFromSuperview()

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
    
    func createDatePickerViewWithAlertController()
    {
        var viewDatePicker: UIView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 200))
        viewDatePicker.backgroundColor = UIColor.clearColor()
        
        
        self.datePicker = UIDatePicker(frame: CGRectMake(0, 0, self.view.frame.size.width, 200))
        self.datePicker!.datePickerMode = UIDatePickerMode.DateAndTime
        self.datePicker!.addTarget(self, action: "datePickerSelected", forControlEvents: UIControlEvents.ValueChanged)
        
        viewDatePicker.addSubview(self.datePicker!)
        
        
        if(UIDevice.currentDevice().systemVersion >= "8.0")
        {
            
            let alertController = UIAlertController(title: nil, message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: UIAlertControllerStyle.ActionSheet)
            
            alertController.view.addSubview(viewDatePicker)
            
            
            
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel)
            { (action) in
                // ...
            }
            
            alertController.addAction(cancelAction)
            
            let OKAction = UIAlertAction(title: "Done", style: .Default)
            { (action) in
                
                self.dateSelected()
            }
            
            alertController.addAction(OKAction)
            
            /*
             let destroyAction = UIAlertAction(title: "Destroy", style: .Destructive)
             { (action) in
             println(action)
             }
             alertController.addAction(destroyAction)
             */
            
            self.presentViewController(alertController, animated: true)
            {
                // ...
            }
            
        }
        else
        {
            let actionSheet = UIActionSheet(title: "\n\n\n\n\n\n\n\n\n\n", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: "Done")
            actionSheet.addSubview(viewDatePicker)
            actionSheet.showInView(self.view)
        }
        
    }
    
    func datePickerSelected()
    {
        
    
    }
    
    
    func dateSelected()
    {
        var selectedDate: String = String()
        
        selectedDate =  self.dateformatterDateTime(self.datePicker!.date) as String
        if(self.selectedTimeLable ==  self.departureTimeLable)
        {
            self.departureTimeLable.text =  selectedDate
        }else if (self.selectedTimeLable == self.returnTimeLable)
        {
            self.returnTimeLable.text =  selectedDate
        }
        
        
        if(compareTime() == false)
        {
            self.returnTimeLable.text = "Pick return date and time"
        }
        
    }
    
    
    func dateformatterDateTime(date: NSDate) -> NSString
    {
        var dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy h:mm a"
        return dateFormatter.stringFromDate(date)
    }
    
    func addActionToDepartDatePicker()
    {
        //departure time
        let singleTap = UITapGestureRecognizer(target: self, action:(#selector(TimePopUpView.oneTapDetected)))
        singleTap.numberOfTapsRequired = 1
        departureTimeLable.userInteractionEnabled = true
        departureTimeLable.addGestureRecognizer(singleTap)
    
        //return time
        
        let oneTap = UITapGestureRecognizer(target: self, action:(#selector(TimePopUpView.singleTapDetected)))
        oneTap.numberOfTapsRequired = 1
        returnTimeLable.userInteractionEnabled = true
        returnTimeLable.addGestureRecognizer(oneTap)

    }
    
    func oneTapDetected()
    {
        self.selectedTimeLable = self.departureTimeLable
        createDatePickerViewWithAlertController()
    
    }
    
    func singleTapDetected()
    
    {
        self.selectedTimeLable = self.returnTimeLable
        createDatePickerViewWithAlertController()

    }
    
    func compareTime() -> Bool
    {
        var validated: Bool = false
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy h:mm a"
       // let date = dateFormatter.dateFromString(/*your_date_string*/)
        guard let departDate = dateFormatter.dateFromString(departureTimeLable.text!)
        else{
            return true
        
        }
        guard let returnDate = dateFormatter.dateFromString(returnTimeLable.text!) else
        
        {
           return true
        }
        
        if(departDate.compare(returnDate) == NSComparisonResult.OrderedAscending)
        {
        
            //validated =
            return true
        }
        
        showAlert()
        return false
    
        //return validated
    }
    
    func showAlert() {
        
        dispatch_async(dispatch_get_main_queue()) {
            
            let alertController = UIAlertController(title: "iOScreator", message:
                "Return date should be later than depart date!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
}
