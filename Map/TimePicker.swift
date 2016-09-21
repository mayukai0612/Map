//
//  TimePicker.swift
//  Map
//
//  Created by Yukai Ma on 19/09/2016.
//  Copyright © 2016 Yukai Ma. All rights reserved.
//

import UIKit

class TimePicker:NSObject{
    
//    func createDatePickerViewWithAlertController()
//    {
//        var viewDatePicker: UIView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 200))
//        viewDatePicker.backgroundColor = UIColor.clearColor()
//        
//        
//        self.datePicker = UIDatePicker(frame: CGRectMake(0, 0, self.view.frame.size.width, 200))
//        self.datePicker!.datePickerMode = UIDatePickerMode.DateAndTime
//        self.datePicker!.addTarget(self, action: "datePickerSelected", forControlEvents: UIControlEvents.ValueChanged)
//        
//        viewDatePicker.addSubview(self.datePicker!)
//        
//        
//        if(UIDevice.currentDevice().systemVersion >= "8.0")
//        {
//            
//            let alertController = UIAlertController(title: nil, message: "\n\n\n\n\n\n\n\n\n\n", preferredStyle: UIAlertControllerStyle.ActionSheet)
//            
//            alertController.view.addSubview(viewDatePicker)
//            
//            
//            
//            
//            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel)
//            { (action) in
//                // ...
//            }
//            
//            alertController.addAction(cancelAction)
//            
//            let OKAction = UIAlertAction(title: "Done", style: .Default)
//            { (action) in
//                
//                self.dateSelected()
//            }
//            
//            alertController.addAction(OKAction)
//            
//            /*
//             let destroyAction = UIAlertAction(title: "Destroy", style: .Destructive)
//             { (action) in
//             println(action)
//             }
//             alertController.addAction(destroyAction)
//             */
//            
//            self.presentViewController(alertController, animated: true)
//            {
//                // ...
//            }
//            
//        }
//        else
//        {
//            let actionSheet = UIActionSheet(title: "\n\n\n\n\n\n\n\n\n\n", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: "Done")
//            actionSheet.addSubview(viewDatePicker)
//            actionSheet.showInView(self.view)
//        }
//        
//    }
//    
//    func datePickerSelected()
//    {
//        
//        
//    }
//    
//    
//    func dateSelected()
//    {
//        var selectedDate: String = String()
//        
//        selectedDate =  self.dateformatterDateTime(self.datePicker!.date) as String
//        if(self.selectedTimeLable ==  self.departureTimeLable)
//        {
//            self.departureTimeLable.text =  selectedDate
//            departureTime = selectedDate
//        }else if (self.selectedTimeLable == self.returnTimeLable)
//        {
//            self.returnTimeLable.text =  selectedDate
//            returnTime = selectedDate
//            
//        }
//        
//        
//        if(compareTime() == false)
//        {
//            self.returnTimeLable.text = "Pick return date and time"
//        }
//        
//    }
//    
//    
//    func dateformatterDateTime(date: NSDate) -> NSString
//    {
//        var dateFormatter: NSDateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "dd-MM-yyyy h:mm a"
//        return dateFormatter.stringFromDate(date)
//    }
//    


}
