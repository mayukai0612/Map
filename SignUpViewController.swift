//
//  SignUpViewController.swift
//  Map
//
//  Created by Yukai Ma on 21/09/2016.
//  Copyright © 2016 Yukai Ma. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController {
    
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func confirmAction(sender: AnyObject) {
        self.emailTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        createUser()
        
    }
    
    func createUser()
    {
        //validate input
        if( !checkInput())
        {
            return
        }
        
        let email = emailTextField.text?.trim()
        let pwd = passwordTextField.text?.trim()
        FIRAuth.auth()?.createUserWithEmail(email!, password: pwd!, completion: {
            (user, error) in
            if error != nil{
                
//                let emailInUseError = "\(error?.userInfo.description.containsString("ERROR_EMAIL_ALREADY_IN_USE"))"
//                
//                let invalidEmailError = "\(error?.userInfo.description.containsString("ERROR_INVALID_EMAIL"))"
//                
//                
                
                //print
                print("!!!!!!!!!!!!!")
                print(error?.code)
                
                //detect wrong email
                if(error?.code == 17008)
                {
                    self.alert("Email invalid", msg: "Please enter a valid email.")
                }
                
                //detect weak password
                if(error?.code == 17026)
                {
                    self.alert("Weak Password", msg: "Password should be at least 6 characters.")
                }
                
                //detect user exsiting
                if(error?.code == 17007)
                {
                    self.alert("User exists", msg: "Please change an email.")
                }
                
                

                
            }
            else{
//                //if user is created, log in
//                let alert = UIAlertController(title: "User created", message: "Welcom!", preferredStyle: .Alert)
//                let action = UIAlertAction(title: "Start", style: .Default, handler: nil)
//                alert.addAction(action)
//                self.presentViewController(alert, animated: true, completion: nil)
                
                self.logIn()
            }
        })
    
    
    }
    
    func logIn()
    {
        let email = emailTextField.text?.trim()
        let pwd = passwordTextField.text?.trim()
        
      
        
        FIRAuth.auth()?.signInWithEmail(email!, password: pwd!, completion: { (user, error) in
            
            if error != nil{
                //detect wrong password
                if(error?.code == 17009)
                {
                    self.alert("Invalid password", msg: "Please retry your password")
                }
                
                //detect no this username exists
                if(error?.code == 17011)
                {
                    self.alert("No user exists", msg: "Please change an email!")
                }
                
                //detect no this username exists
                if(error?.code == 17999)
                {
                    self.alert("Error", msg: "Please input correct information!")
                }
                
                print(error)
                print("incorrect")
                
            }
            else{
                
                print("successfully")
                
                //get userid and store in NSUserDefaults
                let userid = user?.uid
                print(userid)
                NSUserDefaults.standardUserDefaults().setObject(userid, forKey: "userid")
                
                //navigate to the main page
                let sb = UIStoryboard(name: "Main", bundle:nil)
                let vc = sb.instantiateViewControllerWithIdentifier("tabView") as UIViewController
                self.presentViewController(vc, animated: true, completion: nil)
            }
            
            
        })
        
        
    }
    
    func checkInput() -> Bool{
        var result = true
        
        if(emailTextField.text?.trim() == "" || passwordTextField.text?.trim() == "")
        {
            self.alert("Invalid input", msg: "Please do not leave blank!")
            result  = false
        }
        return result
    }
    
    
    func alert(title:String,msg:String){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Got it", style: .Default, handler: nil)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
