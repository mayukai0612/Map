//
//  AnimalInformaition.swift
//  Map
//
//  Created by Yukai Ma on 16/08/2016.
//  Copyright © 2016 Yukai Ma. All rights reserved.
//

import UIKit
import CoreLocation
class AnimalInformation: NSObject {
    
    var title: String?
    var eventDate:String?
    var coordinate: CLLocationCoordinate2D?
    var fileName: String?
    
    init(title:String,eventDate:String,coordinate:CLLocationCoordinate2D)
    {
        self.title = title
        self.eventDate = eventDate
        self.coordinate = coordinate
    }
    
    
    
    
    
    
    

}
