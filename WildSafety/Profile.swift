//
//  Profile.swift
//  Map
//
//  Created by Yukai Ma on 21/09/2016.
//  Copyright © 2016 Yukai Ma. All rights reserved.
//

import UIKit

class Profile: NSObject {
    var vernacularName:String?
    var scientificName:String?
    var desc: String?
    var dangerLevel:String?
    var firstAid:String?
    
    init(vName:String,sName:String,desc:String,dangerLevel:String,firstAid:String) {
        self.vernacularName = vName
        self.scientificName = sName
        self.dangerLevel = dangerLevel
        self.desc = desc
        self.firstAid = firstAid
    }
    
}
