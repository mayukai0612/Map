////
////  TripDescView.swift
////  Map
////
////  Created by Yukai Ma on 28/08/2016.
////  Copyright © 2016 Yukai Ma. All rights reserved.
////
//
//import UIKit
//
//class TripDescView: UIView ,updateTripParameterDelegate{
//    var delegate: addChildViewDelegate?
//    var passParaDelegate:passTripParaDelegate?
//    var tripdesc:String =  ""
//    
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        if let touch = touches.first {
//            
//            let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("descPopUp") as! DescPopUpView
//            popOverVC.delegate = self
//            
//            popOverVC.desc = self.tripdesc
//
//            delegate?.addChildView(popOverVC,viewIdentifier: "tripdesc")
//            
//        }
//    }
//    
//    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        if let touch = touches.first {
//            let currentPoint = touch.locationInView(self)
//            // do something with your currentPoint
//        }
//    }
//    
//    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        if let touch = touches.first {
//            let currentPoint = touch.locationInView(self)
//            // do something with your currentPoint
//        }
//    }
//    
//    func loadViews()
//    {
//        let imageFrame = CGRect(x:155/2 - 15, y: 20 , width: 30, height: 30)
//        //title frame
//        let titleFrame = CGRect(x: 155/2 - 40, y: 30, width: 100, height: 40)
//        
//        //crearte image view
//        let imageView = UIImageView(frame: imageFrame)
//        imageView.contentMode = .ScaleAspectFit
//        let image = UIImage(named: "Description")
//        imageView.image = image
//        
//        //create title
//        let title = UILabel(frame:titleFrame)
//        title.text = "Description"
//        title.font = UIFont (name: "AppleSDGothicNeo-SemiBold", size: 18)
//        let textColor = UIColor(red: 89, green: 45, blue: 23)
//        title.textColor = textColor
//        
//        //self.addSubview(imageView)
//        self.addSubview(title)
//    }
//    func updateTrip(tripPara: String, paraIdentifier: String) {
//        passParaDelegate?.passTripPara(tripPara,paraIdentifier: paraIdentifier)
//        
//    }
//
//    
//}
