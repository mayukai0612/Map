//
//  AddReport.swift
//  Map
//
//  Created by Yukai Ma on 18/09/2016.
//  Copyright © 2016 Yukai Ma. All rights reserved.
//

import UIKit
import MapKit

protocol RefreshDelegate
{

    func refresh()
}

class AddReport: UIViewController ,UIActionSheetDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,PassCategoryDelegate,CLLocationManagerDelegate {


    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    @IBOutlet weak var locationTextField: UITextField!
   
    @IBOutlet weak var categoryView: UIView!
    
  
    @IBOutlet weak var locationView: UIView!
    
    @IBOutlet weak var timeView: UIView!
    
    
    
    @IBOutlet weak var titleTextField: UITextField!
    
    
    @IBOutlet weak var lineBtwTitleAndContext: LineView!
    
    
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var lineBtwContextAndCategory: LineView!
    
    
    @IBOutlet weak var lineBeforeImageView: LineView!
    


    @IBOutlet weak var reportImageView: UIImageView!
    var datePicker: UIDatePicker?
    var selectedDate:NSDate?
    
    let locationManager = CLLocationManager()
    var currentLocCoord: CLLocationCoordinate2D?
    
    let picker = UIImagePickerController()

    var refreshDelegate:RefreshDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
   

        addColorToViewBoard()
        
        //add dashed line
        lineBtwTitleAndContext.addDashedLine()
     lineBtwContextAndCategory.addDashedLine()
        lineBeforeImageView.addDashedLine()
        
        addActionToViews()
        
         getCurrentTime()
        
        //set palceholder for textview
        contentTextView.text = "What's happened"
        contentTextView.textColor = UIColor.lightGrayColor()
        contentTextView.delegate = self
        
        //get rid of board of text field
        self.titleTextField.borderStyle = UITextBorderStyle.None
      self.titleTextField.layer.borderColor = UIColor.clearColor().CGColor
        
        self.locationTextField.borderStyle = UITextBorderStyle.None
        self.locationTextField.layer.borderColor = UIColor.clearColor().CGColor
        
        self.categoryTextField.borderStyle = UITextBorderStyle.None
        self.categoryTextField.layer.borderColor = UIColor.clearColor().CGColor
        self.categoryTextField.userInteractionEnabled = false

        
        //add bar button items to navigtion bar
         addButtonToNavBar()
        
        //add cancle button to keyboard
        addCancleButtonOnKeyboard()
        
        //image picker
        picker.delegate = self
        
        
        //get current location
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // using only when application is in use
        // self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()

        
        self.navigationItem.title = "New Danger"
       // self.navigationController.co
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func addColorToViewBoard()
    {

        self.categoryView.layer.borderWidth = 1
        self.categoryView.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.timeView.layer.borderWidth = 1
        self.timeView.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.locationView.layer.borderWidth = 1
        self.locationView.layer.borderColor = UIColor.lightGrayColor().CGColor
        
    }
    
    func addActionToViews()
    {
        let categoryViewGesture = UITapGestureRecognizer(target: self, action: #selector(AddReport.categoryViewAction(_:)))
        self.categoryView.addGestureRecognizer(categoryViewGesture)
        
        let timeViewGesture = UITapGestureRecognizer(target: self, action: #selector(AddReport.timeViewAction(_:)))
        self.timeView.addGestureRecognizer(timeViewGesture)
        
        let locationViewGesture = UITapGestureRecognizer(target: self, action: #selector(AddReport.locationViewAction(_:)))
        self.locationView.addGestureRecognizer(locationViewGesture)
        
      
    }
    
    
    //.... Set Right Bar Button items
    func addButtonToNavBar()
    {
    
        let btnName = UIButton()
        btnName.setImage(UIImage(named: "Camera"), forState: .Normal)
        btnName.frame = CGRectMake(0, 0, 30, 30)
        btnName.addTarget(self, action: #selector(AddReport.showActionSheet), forControlEvents: .TouchUpInside)
        let rightBarButtonItemOne = UIBarButtonItem()
        rightBarButtonItemOne.customView = btnName
        
        let rightBarButtonItemTwo = UIBarButtonItem(title: "Save", style: .Plain, target: self, action: #selector(save))
        rightBarButtonItemTwo.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItems = [rightBarButtonItemTwo,rightBarButtonItemOne]
    }
   
    //access camera
    func camera()
    {
        picker.sourceType = UIImagePickerControllerSourceType.Camera
        
        self.presentViewController(picker, animated: true, completion: nil)
        
    }
    
    //access photolibrary
    func photoLibrary()
    {
        picker.allowsEditing = false
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(picker, animated: true, completion: nil)
    
    }
    
    // save report
    func save()
    {
        if(!checkInput())
        {
            //alert
            let alert = UIAlertController(title: "Empty input", message: "Please do not leave title and content empty!", preferredStyle: .Alert)
            let action = UIAlertAction(title: "Got it", style: .Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        else
        {
        //save report
            //get userid
            let userid = NSUserDefaults.standardUserDefaults().stringForKey("userid")!
            //get time
            let date = NSDate()
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
            
            let dateformatter = NSDateFormatter()
            dateformatter.dateFormat = "ddMMyyyyHH:mm:ss"
            let timeStamp = dateformatter.stringFromDate(date)
            
            //save
            let reportCategory = categoryTextField.text
            let reportTitle = titleTextField.text
            let reportContent = contentTextView.text
            let reportTime =  dateFormatter.stringFromDate(selectedDate!)
            let reportLat = -37.866684
            let reportLgt = 145.039362
            
            let reportAddress = locationTextField.text?.trim()
            
            if(self.reportImageView.image != nil){
            let reportImageFileName = String(userid) + "_" + timeStamp + ".jpg" // need to be unique
                let report  = Report(userid:userid,reportCat:reportCategory!,reportTitle:reportTitle!,reportContent:reportContent,reportTime:reportTime,reportLat:reportLat,reportLgt:reportLgt,reportAddress:reportAddress!,imageFileName:reportImageFileName)
            
            let reportDB = ReportDB()
                
                let image  = self.reportImageView.image
                let resizeImage = self.resizeImage(image!, newWidth: 200)
                var imageArray = [UIImage]()
                imageArray.append(resizeImage)
            
                reportDB.saveReport(report,imageArray:imageArray,navigationController: self.navigationController!)
            }
            else{
                let reportImageFileName = ""
                let report  = Report(userid:userid,reportCat:reportCategory!,reportTitle:reportTitle!,reportContent:reportContent,reportTime:reportTime,reportLat:reportLat,reportLgt:reportLgt,reportAddress:reportAddress!,imageFileName:reportImageFileName)
                
                let reportDB = ReportDB()
                reportDB.saveReport(report,imageArray: [UIImage](),navigationController: self.navigationController!)
            }
            
            
            //dismiss and refresh the view
            self.navigationController?.popViewControllerAnimated(true)
            dispatch_async(dispatch_get_main_queue(), { 
                self.refreshDelegate?.refresh()
            })
            
        }
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight))
        image.drawInRect(CGRectMake(0, 0, newWidth, newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }

    
    //check input
    func checkInput() -> Bool
    {   var validation = true
        if(self.titleTextField.text?.trim() == "" || self.contentTextView.text == "What's happended")
        {
            validation = false
        }
        return validation
    }
    
    
    func categoryViewAction(sender:UITapGestureRecognizer)
    {
        print("category")
        //popp up a window to choose category
        self.addChildView()
        
        
    }
    
    func timeViewAction(sender:UITapGestureRecognizer)
    {
        print("time")
        //choose time
        createDatePickerViewWithAlertController()
    }
    
    func locationViewAction(sender:UITapGestureRecognizer)
    {
        print("location")
        //choose location
    }
    // show action sheet of choosing photo
    
    //action sheet used to pick photos or take pictures using a camera
    func showActionSheet() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: UIAlertActionStyle.Default, handler: { (alert:UIAlertAction!) -> Void in self.camera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: UIAlertActionStyle.Default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        
        self.presentViewController(actionSheet, animated: true, completion: nil)
        
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            reportImageView.contentMode = .ScaleAspectFit
            reportImageView.image = pickedImage
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    //add category child view to choose category
    func addChildView()
    {
        //convert AnyClass to specific type
        let popUpView = self.storyboard?.instantiateViewControllerWithIdentifier("ReportCategoryPopUp") as! ReportCategoryPopUpView
        popUpView.passCategoryDelegate  = self
        self.addChildViewController(popUpView)
        popUpView.view.frame = self.view.frame
        self.view.addSubview(popUpView.view)
        popUpView.didMoveToParentViewController(self)
    }
    
    //date picker
    
    func createDatePickerViewWithAlertController()
    {
        let viewDatePicker: UIView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 200))
        viewDatePicker.backgroundColor = UIColor.clearColor()
        
        
        self.datePicker = UIDatePicker(frame: CGRectMake(0, 0, self.view.frame.size.width, 200))
        self.datePicker!.datePickerMode = UIDatePickerMode.DateAndTime
        self.datePicker!.addTarget(self, action: #selector(AddReport.datePickerSelected), forControlEvents: UIControlEvents.ValueChanged)
        
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
        
        self.selectedDate = self.datePicker!.date
        timeLabel.text =  self.dateformatterDateTime(self.datePicker!.date) as String
    }
    
    
    func dateformatterDateTime(date: NSDate) -> NSString
    {
        let dateFormatter: NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy h:mm a"
        return dateFormatter.stringFromDate(date)
    }
    
    func getCurrentTime()
    {
        let date = NSDate()
        let currenTime =  dateformatterDateTime(date)
        self.timeLabel.text = currenTime as String
        self.selectedDate  =  date
    }
    
    
    //get currnet locations
    
    
    //text view delegate method - begin editing
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
    }
    
    //text view delegate method - end editing
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "What's happened"
            textView.textColor = UIColor.lightGrayColor()
        }
    }
    
    //add cancle to keyboard
    
    func addCancleButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
        doneToolbar.barStyle = UIBarStyle.Default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Cancle", style: UIBarButtonItemStyle.Done, target: self, action: #selector(AddReport.cacleButtonAction))
        
        var items = [UIBarButtonItem]()
        items.append(flexSpace)
        items.append(done)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
   
      
        
        self.titleTextField.inputAccessoryView = doneToolbar
        self.contentTextView.inputAccessoryView = doneToolbar
        self.locationTextField.inputAccessoryView = doneToolbar
        
       

        
    }
    
    func donePicker(){}
    
    func cacleButtonAction()
    {
        self.titleTextField.resignFirstResponder()
        self.contentTextView.resignFirstResponder()
        self.locationTextField.resignFirstResponder()

    }
    
    //delegate method
    
    func passCategory(category: String) {
        self.categoryTextField.text = category
    }
    
    
    //location magager delegate method
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        
        let center = CLLocationCoordinate2DMake(location!.coordinate.latitude,location!.coordinate.longitude)
        
        let region = MKCoordinateRegionMake(center, MKCoordinateSpanMake(0.5, 0.5))
        
        
        self.locationManager.stopUpdatingLocation()
        
        if(self.currentLocCoord == nil){
            currentLocCoord =  locations.last!.coordinate
            
           // self.loadWeather?.getWeatherFor(currentLocCoord!.latitude, longitude: currentLocCoord!.longitude)
            
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Error" + error.localizedDescription)
    }
    
    

    
}

extension UIImage {

class func dottedLine(radius radius: CGFloat, space: CGFloat, numberOfPattern: CGFloat) -> UIImage {
    
    
    let path = UIBezierPath()
    path.moveToPoint(CGPointMake(radius/2, radius/2))
    path.addLineToPoint(CGPointMake((numberOfPattern)*(space+1)*radius, radius/2))
    path.lineWidth = radius
    
    let dashes: [CGFloat] = [path.lineWidth * 0, path.lineWidth * (space+1)]
    path.setLineDash(dashes, count: dashes.count, phase: 0)
    path.lineCapStyle = CGLineCap.Round
    
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake((numberOfPattern)*(space+1)*radius, radius), false, 1)
    UIColor.whiteColor().setStroke()
    path.stroke()
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return image
    }
}
