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

class SignUpViewController: UIViewController {

    let roofRef = FIRDatabase.database().reference()
    
    
    @IBOutlet weak var emailLabel: UITextField!
    
    @IBOutlet weak var passwordLabel: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                    print("Emial in user error!!")
                }
                
                if( invalidEmailError == "true")
                {
                
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
        FIRAuth.auth()?.signInWithEmail(emailLabel.text!, password: passwordLabel.text!, completion: { (user, error) in
            
            if error != nil{
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
    
    /*
     This method will save user's information into the Firebase
     and record user's login state.
     */
    
//    @IBAction func signUpAction(sender: AnyObject) {
//        let name = self.userNameTextField.text
//        let password = self.passwordTextField.text
//        let confirmPassword = self.confirmPasswordTextField.text
//        let mobilePhone = self.mobilePhoneTextField.text
//        let email = self.emailTextField.text
//        
//        if password != confirmPassword {
//            self.alertConfirmPassword()
//        } else if name != "" && password != "" && confirmPassword != "" && mobilePhone != "" && email != "" {
//            FIREBASE_REF.createUser(email, password: password, withValueCompletionBlock: { (error, result) -> Void in
//                if error == nil {
//                    FIREBASE_REF.authUser(email, password: password, withCompletionBlock: { (error, authData) -> Void in
//                        if error == nil {
//                            // Record user's login state.
//                            NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: "uid")
//                            // Retrieve current user's user ID.
//                            let uid = result["uid"] as? String
//                            // Append user's information to Firebase.
//                            let userInfo = ["name" : name!, "password" : password!, "address" : address!, "mobilePhone" : mobilePhone!, "email" : email!]
//                            FIREBASE_REF.childByAppendingPath("users/\(uid!)/info").setValue(userInfo)
//                            // Append user's order index
//                            let index = 0
//                            let orderIndex = ["index": index]
//                            FIREBASE_REF.childByAppendingPath("users/\(uid!)/count").setValue(orderIndex)
//                            // Remind user that they have registered successfully.
//                            self.alertRegisterSuccessfully()
//                            print("Account registered successfully with the userID: \(uid!)")
//                        } else {
//                            print(error)
//                        }
//                    })
//                } else {
//                    print(error)
//                    self.checkRegisterInput(error.description)
//                }
//            })
//        } else {
//            self.alertIfHasEmptyInput()
//        }
//        
//    }
    
    
//    //get userid
//    func getUserid() -> String{
//           var userid = NSUserDefaults.standardUserDefaults().stringForKey("userid")
//            if(userid != nil){
//                    return userid!
//                 }else{
//                    var uuid_ref = CFUUIDCreate(nil)
//                var uuid_string_ref = CFUUIDCreateString(nil , uuid_ref)
//                    var uuid:String = NSString(format: uuid_string_ref)
//                  NSUserDefaults.standardUserDefaults().setObject(uuid, forKey: "hangge")
//                   return uuid
//            }
//   }
//   
    /*
     When password doesn't match the confirmPassword, call this method.
     The method will show an alert to remind users.
     */
    func alertConfirmPassword() -> Void {
        let alert = UIAlertController(title: "Sorry", message: "Confirm Password Incorrectly...", preferredStyle: .Alert)
        let action = UIAlertAction(title: "Got it", style: .Default, handler: nil)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    /*
     When users don't fill all the TextFields, call this method.
     The method will show an alert to remind users.
     */
    func alertIfHasEmptyInput() -> Void {
        let alert = UIAlertController(title: "Sorry", message: "Empty input cannot be accepted...", preferredStyle: .Alert)
        let action = UIAlertAction(title: "Got it", style: .Default, handler: nil)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    /*
     When user register successfully, system will popup an alert to remind users.
     */
    func alertRegisterSuccessfully() -> Void {
        let alert = UIAlertController(title: "Congratulations", message: "You've registered successfully!", preferredStyle: .Alert)
        let action = UIAlertAction(title: "Got it", style: .Default, handler: nil)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func checkRegisterInput(error: String) -> Void {
        if error.rangeOfString("-9") != nil {
            let alert = UIAlertController(title: "Sorry", message: "The specified email address is already in use...", preferredStyle: .Alert)
            let action = UIAlertAction(title: "Got it", style: .Default, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

































