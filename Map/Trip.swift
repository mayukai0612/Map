//
//  Trip.swift
//  Map
//
//  Created by Yukai Ma on 27/08/2016.
//  Copyright © 2016 Yukai Ma. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase

class Trip: NSObject {


    var tripID: String?
    var userID: String?
    var category: String?
    var tripTitle:String?
    var departTime: String?
    var returnTime: String?
    var lat: String?
    var lgt: String?

    var imagefilename = [String]()
    var tripImage:UIImage?
    
    override init() {
        
    }
    
    init(category: String,tripTitle: String,departTime: String) {
        self.category = category
        self.tripTitle = tripTitle
        self.departTime = departTime
        
    }
    init(tripID: String,userID: String,category: String,tripTitle: String,departTime: String,returnTime: String,lat:String,lgt:String,imagefilename: [String])
    {
        self.tripID = tripID
        self.userID = userID
        
        self.category = category
        self.tripTitle = tripTitle
        self.departTime = departTime
        self.returnTime  = returnTime
        self.lat = lat
        self.lgt = lgt
    
        self.imagefilename = imagefilename
    }
    
    init(category: String,tripTitle: String,departTime: String,returnTime: String,lat:String,lgt:String,imagefilename: [String])
    {
      
        self.category = category
        self.tripTitle = tripTitle
        self.departTime = departTime
        self.returnTime  = returnTime
        self.lat = lat
        self.lgt = lgt
       
        self.imagefilename = imagefilename
    }

    init(departTime:String,whatsAbout:String,tripLoc:String) {
        
        self.departTime = departTime
        self.tripTitle = whatsAbout
        self.lat = tripLoc
        
    }
    
    
}
