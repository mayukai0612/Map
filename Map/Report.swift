//
//  Report.swift
//  Map
//
//  Created by Yukai Ma on 19/09/2016.
//  Copyright © 2016 Yukai Ma. All rights reserved.
//

import UIKit

class Report:NSObject{

    var userid: String?
    var reportid: Int?
    var reportCategory:String?
    var reportTitle:String?
    var reportContent:String?
    var reportTime:String?
    var reportLat:Double?
    var reportLgt:Double?
    var reportAddress:String?
    var imageFileName:String?
    
    
    init(userid:String,reportCat:String,reportTitle:String,reportContent:String,reportTime:String,reportLat:Double,reportLgt:Double,reportAddress:String,imageFileName:String) {
        self.userid = userid
        self.reportCategory = reportCat
        self.reportTitle  = reportTitle
        self.reportContent  = reportContent
        self.reportLat = reportLat
        self.reportLgt = reportLgt
        self.reportTime = reportTime
        self.imageFileName = imageFileName
        self.reportAddress = reportAddress
    }

    init(userid:String,reportid:Int,reportCat:String,reportTitle:String,reportContent:String,reportTime:String,reportLat:Double,reportLgt:Double,reportAddress:String,imageFileName:String) {
        self.userid = userid
        self.reportid = reportid
        self.reportCategory = reportCat
        self.reportTitle  = reportTitle
        self.reportContent  = reportContent
        self.reportLat = reportLat
        self.reportLgt = reportLgt
        self.reportTime = reportTime
        self.imageFileName = imageFileName
        self.reportAddress = reportAddress
    }



}
