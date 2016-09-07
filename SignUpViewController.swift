//
//  SignUpViewController.swift
//  Map
//
//  Created by Yukai Ma on 28/08/2016.
//  Copyright © 2016 Yukai Ma. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
class SignUpViewController: UIViewController {

    let roofRef = FIRDatabase.database().reference()
    
    
    @IBOutlet weak var emailLabel: UITextField!
    
    @IBOutlet weak var passwordLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //change background color of view
        let backGroundColor = UIColor(red: 86, green: 171, blue: 59)
        self.view.backgroundColor = backGroundColor

        
        //dimiss keyboard when tapping on view
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        
    }
    
    @IBAction func createAccount(sender: AnyObject) {
        
        FIRAuth.auth()?.createUserWithEmail(emailLabel.text!, password: passwordLabel.text!, completion: {
            (user, error) in
            if error != nil{
                
                let emailInUseError = "\(error?.userInfo.description.containsString("ERROR_EMAIL_ALREADY_IN_USE"))"
                
                let invalidEmailError = "\(error?.userInfo.description.containsString("ERROR_INVALID_EMAIL"))"

                
                if( emailInUseError ==  "true"){
                    print( emailInUseError)
                    self.errorAlert("Email in use",msg: "Please retry another email.")
                    print("Emial in user error!!")
                }
                
                if( invalidEmailError == "true")
                {
                    self.errorAlert("Email invalid",msg: "Please enter a valid email.")
                    print("invalid email error!")
                }
                
                
                self.login()
            }
            else{
            
                print("user created!!")
                self.login()
            }
        })
    }
    
    func login()
    {
        //validate input
        if( !checkUserInput())
        {
            return
        }
        
        FIRAuth.auth()?.signInWithEmail(emailLabel.text!, password: passwordLabel.text!, completion: { (user, error) in
            
            if error != nil{
                //detect wrong password
                if(error?.code == 17009)
                {
                    self.errorAlert("Invalid password", msg: "Please retry your password")
                }
                
                //detect no this username exists
                if(error?.code == 17011)
                {
                    self.errorAlert("No user exists", msg: "Please change an email!")
                }
                
                //detect no this username exists
                if(error?.code == 17999)
                {
                    self.errorAlert("Error", msg: "Please input correct information!")
                }
                
                print(error)
                print("incorrect")
            
            }
            else{
              
                print("successfully")
                
                //get userid and store in NSUserDefaults
                let userid = user?.uid
                NSUserDefaults.standardUserDefaults().setObject(userid, forKey: "userid")
                
                //navigate to the main page
                let sb = UIStoryboard(name: "Main", bundle:nil)
                let vc = sb.instantiateViewControllerWithIdentifier("tabView") as UIViewController
                self.presentViewController(vc, animated: true, completion: nil)
            }
            
            
        })
    
    
    }
    
    /*
     Calls this function when the tap is recognized.
     */
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func checkUserInput() -> Bool{
        var result = true
        
        if(emailLabel.text?.trim() == "" || passwordLabel.text?.trim() == "")
        {
            errorAlert("Invalid input", msg: "Please do not leave blank!")
            result  = false
        }
        return result
    }
    
    
    /*
     When some error happen or prompt needed, call this method.
     The method will show an alert to remind users.
     */
    func errorAlert(title:String,msg:String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Got it", style: .Default, handler: nil)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    

    
}





extension String
{
    func trim() -> String
    {
        return self.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    }
}



























