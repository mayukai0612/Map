//
//  TripPhoto.swift
//  Map
//
//  Created by Yukai Ma on 28/08/2016.
//  Copyright © 2016 Yukai Ma. All rights reserved.
//

import UIKit

protocol cameraAndPicLibDelegate {
    func showActionSheet()
}

class TripPhotoView: UIView {
    
    var delegate: cameraAndPicLibDelegate?
    var imageView: UIImageView?
    var imagefilename: String?
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first {
            
            
            delegate?.showActionSheet()
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
        let image = UIImage(named: "Camera")
        imageView.image = image
        
        //create title
        let title = UILabel(frame:titleFrame)
        title.lineBreakMode = NSLineBreakMode.ByWordWrapping
        title.numberOfLines = 2
        title.text = "Add photo"
        title.font = UIFont (name: "AppleSDGothicNeo-SemiBold", size: 18)
        let textColor = UIColor(red: 89, green: 45, blue: 23)
        title.textColor = textColor
        
        self.addSubview(imageView)
        self.addSubview(title)
    }
    
    
    func updateImage(image:UIImage)
    {
        //remomve from subviews
        self.subviews.forEach({ $0.removeFromSuperview() }) // this gets things done

        //crearte image view
        let imageFrame = CGRect(x:0, y: 0 , width: 155, height: 100)
         self.imageView = UIImageView(frame: imageFrame)
       self.imageView!.contentMode = .ScaleAspectFill
        imageView?.image = image
        self.addSubview(imageView!)
    }
    
    
    func loadImage(url:String)
    {
        //remomve from subviews
        self.subviews.forEach({ $0.removeFromSuperview() }) // this gets things done
        
        //crearte image view
        let imageFrame = CGRect(x:0, y: 0 , width: 155, height: 100)
        self.imageView = UIImageView(frame: imageFrame)
        self.imageView!.contentMode = .ScaleAspectFill
        
        let tripDB = TripDB()
        self.addSubview(imageView!)
      //  tripDB.loadImageFromUrl(url, view: self.imageView!)

      //  imageView?.image = image
    }
    
    
    
    
   

}
