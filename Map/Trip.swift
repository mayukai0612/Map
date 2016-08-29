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

    var tripID: Int?
    var userID: Int?
    var category: String?
    var departTime: String?
    var returnTime: String?
    var tripLoc: String?
    var emergencyContact: String?
    var tripDesc: String?
    var photoUrl: String?
    var whatsAbout: String?
    var photoCoordinate: CLLocationCoordinate2D?
    
    init(tripID: Int,userID: Int,category: String,departTime: String,returnTime: String,tripLoc: String,emergencyContact: String,tripDesc: String,photoUrl: String, whatsAbout: String,photoCoordinate:CLLocationCoordinate2D?)
    {
        self.category = category
        self.departTime = departTime
        self.tripID = tripID
        self.emergencyContact = emergencyContact
        self.photoUrl = photoUrl
        self.photoCoordinate = photoCoordinate
        self.returnTime = returnTime
        self.whatsAbout = whatsAbout
        self.tripLoc = tripLoc
        self.tripDesc = tripDesc
        
        
    }
    
    init(departTime:String,whatsAbout:String,tripLoc:String) {
        
        self.departTime = departTime
        self.whatsAbout = whatsAbout
        self.tripLoc = tripLoc
        
    }
    
    
}
