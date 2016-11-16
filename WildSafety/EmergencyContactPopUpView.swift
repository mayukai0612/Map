//
//  EmergencyContactPopUpView.swift
//  Map
//
//  Created by Yukai Ma on 28/08/2016.
//  Copyright © 2016 Yukai Ma. All rights reserved.
//

import UIKit

class EmergencyContactPopUpView: UIViewController {
    
    @IBOutlet weak var nameLabel: UITextField!
    
    @IBOutlet weak var contactLable: UITextField!
    
    @IBOutlet weak var emailLable: UITextField!
    
    @IBOutlet weak var closeBtn: UIImageView!
    
    @IBOutlet weak var displayedView: UIView!

    var delegate: updateTripParameterDelegate?
    var emergencyName:String = ""
    var emergencyPhone:String = ""
    var emergencyEmail:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
        
        self.displayedView.layer.cornerRadius = 5
        self.displayedView.layer.masksToBounds = true
        addActionOnCloseBtn()

        self.showAnimate()
        
        // Do any additional setup after loading the view.
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(EmergencyContactPopUpView.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EmergencyContactPopUpView.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(EmergencyContactPopUpView.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        loadInitialViews()

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
    
  
    @IBAction func doneBtnAction(sender: AnyObject) {
        if let emergencyContactName = nameLabel.text
        {
            delegate?.updateTrip(emergencyContactName,paraIdentifier: "emergencyContactName")

        }
        if let emergencyContactPhone = contactLable.text
        {
            delegate?.updateTrip(emergencyContactPhone,paraIdentifier: "emergencyContactPhone")

        }
        if let emergencyContactEmail = emailLable.text
        {
            delegate?.updateTrip(emergencyContactEmail,paraIdentifier: "emergencyContactEmail")
        }
        
        self.view.removeFromSuperview()

    }
    
    func loadInitialViews()
    {
        nameLabel.text = self.emergencyName
        contactLable.text = self.emergencyPhone
        emailLable.text = self.emergencyEmail
    }
    
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
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyboardSize.height/2 - 10
            }
            else {
                
            }
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height/2 - 10
            }
            else {
                print("bug")
            }
        }
    }
    

}