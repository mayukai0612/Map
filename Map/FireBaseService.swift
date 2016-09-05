////
////  FireBaseService.swift
////  Map
////
////  Created by Yukai Ma on 28/08/2016.
////  Copyright © 2016 Yukai Ma. All rights reserved.
////
//
//import Foundation
//import Firebase
//
//let BASE_URL = "https://amber-torch-9110.firebaseio.com/"
//var FIREBASE_REF = Firebase(url: BASE_URL)
//var CURRENT_USER: Firebase {
//    let userID = NSUserDefaults.standardUserDefaults().valueForKey("uid") as! String
//    let currentUser = Firebase(url: "\(FIREBASE_REF)").childByAppendingPath("users").childByAppendingPath(userID)
//    return currentUser!
//}