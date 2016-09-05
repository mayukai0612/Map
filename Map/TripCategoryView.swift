//
//  CategoryView.swift
//  Map
//
//  Created by Yukai Ma on 26/08/2016.
//  Copyright © 2016 Yukai Ma. All rights reserved.
//

import UIKit

protocol passTripParaDelegate {
    func passTripPara(tripPara:String,paraIdentifier:String)
}

protocol  addChildViewDelegate {
    func addChildView(popUpView: UIViewController,viewIdentifier:String)
}

class TripCategoryView: UIView ,updateTripParameterDelegate{
    
   
    var delegate: addChildViewDelegate?
    var passParaDelegate: passTripParaDelegate?
    var category:String?
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            
            let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("categoryPopUp") as! CategoryPopupView
            popOverVC.delegate = self
            //pass category value to pop up view
            if (self.category != nil){
            popOverVC.category = self.category!
            }
            delegate?.addChildView(popOverVC,viewIdentifier: "category")

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
    
    func changeView() {
        
        loadViews()
    }
 
    func loadViews()
    {
        let imageFrame = CGRect(x:155/2 - 15, y: 20 , width: 30, height: 30)
        //title frame
        let titleFrame = CGRect(x: 155/2 - 20, y: 50, width: 80, height: 40)
        
        //crearte image view
        let imageView = UIImageView(frame: imageFrame)
        imageView.contentMode = .ScaleAspectFit
        let image = UIImage(named: "Group")
        imageView.image = image
        
        //create title
        let title = UILabel(frame:titleFrame)
        title.text = "Group"
        title.font = UIFont (name: "AppleSDGothicNeo-SemiBold", size: 18)
        let textColor = UIColor(red: 89, green: 45, blue: 23)
        title.textColor = textColor
        
        self.addSubview(imageView)
        self.addSubview(title)
    }
  
    func updateTrip(tripPara:String,paraIdentifier:String) {
        
        passParaDelegate?.passTripPara(tripPara,paraIdentifier: paraIdentifier)
        
    }

}
