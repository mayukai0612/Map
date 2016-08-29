//
//  TripEmergencyContactView.swift
//  Map
//
//  Created by Yukai Ma on 28/08/2016.
//  Copyright © 2016 Yukai Ma. All rights reserved.
//

import UIKit

class TripEmergencyContactView: UIView {
    var delegate: addChildViewDelegate?
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            
            let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("emergencyPopUp") as! EmergencyContactPopUpView
            delegate?.addChildView(popOverVC)
            
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let currentPoint = touch.locationInView(self)
            // do something with your currentPoint
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            let currentPoint = touch.locationInView(self)
            // do something with your currentPoint
        }
    }
    func loadViews()
    {
        let imageFrame = CGRect(x:155/2 - 15, y: 20 , width: 30, height: 30)
        //title frame
        let titleFrame = CGRect(x: 155/2 - 40, y: 50, width: 88, height: 40)
        
        //crearte image view
        let imageView = UIImageView(frame: imageFrame)
        imageView.contentMode = .ScaleAspectFit
        let image = UIImage(named: "Phone")
        imageView.image = image
        
        //create title
        let title = UILabel(frame:titleFrame)
        title.lineBreakMode = NSLineBreakMode.ByWordWrapping
        title.numberOfLines = 2
        title.text = "Emergency Contact"
        title.font = UIFont (name: "AmericanTypewriter-Bold", size: 15)
        title.textColor = UIColor.blackColor()
        
        self.addSubview(imageView)
        self.addSubview(title)
    }
    
}