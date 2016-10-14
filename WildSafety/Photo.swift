//
//  Photo.swift
//  Map
//
//  Created by Yukai Ma on 17/09/2016.
//  Copyright © 2016 Yukai Ma. All rights reserved.
//

import UIKit

class Photo:UIImage{
    
    var image:UIImage?
    var index:Int?

    
     init(image:UIImage,index:Int?)
    {
        super.init()
        self.image = image
        self.index = index
    }
    
    required convenience init(imageLiteral name: String) {
        fatalError("init(imageLiteral:) has not been implemented")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
 
    

}

