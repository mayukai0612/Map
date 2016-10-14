//
//  TitlePopUpView.swift
//  Map
//
//  Created by Yukai Ma on 28/08/2016.
//  Copyright © 2016 Yukai Ma. All rights reserved.
//

import UIKit

class TitlePopUpView: UIViewController ,UITextViewDelegate{
    
    var delegate: updateTripParameterDelegate?
    var tripTitle:String = ""
    
    @IBOutlet weak var titleTextView: UITextView!
    
    @IBOutlet weak var displayedView: UIView!

    @IBAction func doneBtnAction(sender: AnyObject) {
        
        if let inputTitle = titleTextView.text{
            delegate?.updateTrip(inputTitle,paraIdentifier: "title")
        }
        

        self.view.removeFromSuperview()

    }
    

    @IBOutlet weak var closeBtn: UIImageView!
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
        
        self.displayedView.layer.cornerRadius = 5
        self.displayedView.layer.masksToBounds = true
        addActionOnCloseBtn()

        self.showAnimate()
        
        //set palceholder for textview
        titleTextView.text = "Enter your main topic here"
        titleTextView.textColor = UIColor.lightGrayColor()
        titleTextView.delegate = self
        
        // tap view to dismiss keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(TitlePopUpView.dismissKeyboard))
        view.addGestureRecognizer(tap)

        //oberser keyboard
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TitlePopUpView.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(TitlePopUpView.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
        
        
        //load initial views
        loadIntialViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
 
    
    @IBAction func ClosePopUp(sender: AnyObject) {
        self.view.removeFromSuperview()
        
    }
    
    func loadIntialViews()
    {
        if(self.tripTitle != "")
        {
            titleTextView.text = self.tripTitle
        }
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
                
            }
        }
    }
    
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if textView.textColor == UIColor.lightGrayColor() {
            if(self.tripTitle == ""){
            textView.text = nil
            }
            textView.textColor = UIColor.blackColor()
        }
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter you main topic here.."
            textView.textColor = UIColor.lightGrayColor()
        }
    }
}
