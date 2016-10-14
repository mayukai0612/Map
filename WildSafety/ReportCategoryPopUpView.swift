//
//  ReportCategoryPopUpView.swift
//  Map
//
//  Created by Yukai Ma on 19/09/2016.
//  Copyright © 2016 Yukai Ma. All rights reserved.
//

import UIKit

protocol  PassCategoryDelegate {
    func passCategory(category:String)
}

class ReportCategoryPopUpView: UIViewController {

    @IBOutlet weak var closeBtn: UIImageView!
    
    @IBOutlet weak var displayedView: UIView!
    
    @IBOutlet weak var AnimalsImage: UIImageView!
    
    @IBOutlet weak var WeatherImage: UIImageView!
    
    
    @IBOutlet weak var FireImage: UIImageView!
    
    @IBOutlet weak var FloodImage: UIImageView!
    
    @IBOutlet weak var RoadCondition: UIImageView!
    
    
    
    @IBOutlet weak var WildLifeThreatImage:
     UIImageView!
    
    @IBOutlet weak var OtherImage: UIImageView!
    
    var choosedCategory: String?
    var passCategoryDelegate: PassCategoryDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
        
        self.displayedView.layer.cornerRadius = 5
        self.displayedView.layer.masksToBounds = true
        
        addActionOnImages()
        makeRoundCornerForOptions()
        
        self.showAnimate()
        
        
      
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func DoneAction(sender: AnyObject) {
        
        //pass category to the add category view
        passCategoryDelegate?.passCategory(choosedCategory!)
        self.view.removeFromSuperview()

    }
    
    func showAnimate()
    {
        self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
        self.view.alpha = 0.0;
        UIView.animateWithDuration(0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransformMakeScale(1.0, 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animateWithDuration(0.25, animations: {
            self.view.transform = CGAffineTransformMakeScale(1.3, 1.3)
            self.view.alpha = 0.0;
            }, completion:{(finished : Bool)  in
                if (finished)
                {
                    self.view.removeFromSuperview()
                }
        });
    }
    
    
    
    func  addActionOnImages() {
        //close btn
        let singleTap = UITapGestureRecognizer(target: self, action:(#selector(ReportCategoryPopUpView.dismissView)))
        singleTap.numberOfTapsRequired = 1
        closeBtn.userInteractionEnabled = true
        closeBtn.addGestureRecognizer(singleTap)
        
        //Animals option
        let animalImageGesture = UITapGestureRecognizer(target: self, action:(#selector(ReportCategoryPopUpView.animalSelected)))
        animalImageGesture.numberOfTapsRequired = 1
        AnimalsImage.userInteractionEnabled = true
        AnimalsImage.addGestureRecognizer(animalImageGesture)
        
        //Weather option
        
        let weatherImageGesture = UITapGestureRecognizer(target: self, action:(#selector(ReportCategoryPopUpView.weatherSelected)))
        weatherImageGesture.numberOfTapsRequired = 1
        WeatherImage.userInteractionEnabled = true
        WeatherImage.addGestureRecognizer(weatherImageGesture)
        
        
        //Fire option
        
        let fireImageGesture = UITapGestureRecognizer(target: self, action:(#selector(ReportCategoryPopUpView.fireSelected)))
        fireImageGesture.numberOfTapsRequired = 1
        FireImage.userInteractionEnabled = true
        FireImage.addGestureRecognizer(fireImageGesture)
        
        //Flood option
        
        let floodImageGesture = UITapGestureRecognizer(target: self, action:(#selector(ReportCategoryPopUpView.floodSelected)))
        floodImageGesture.numberOfTapsRequired = 1
        FloodImage.userInteractionEnabled = true
        FloodImage.addGestureRecognizer(floodImageGesture)
        
        //Road condition option
        let roadConditionImageGesture = UITapGestureRecognizer(target: self, action:(#selector(ReportCategoryPopUpView.roadConditionSelected)))
        roadConditionImageGesture.numberOfTapsRequired = 1
        RoadCondition.userInteractionEnabled = true
        RoadCondition.addGestureRecognizer(roadConditionImageGesture)
        
        //Wild threat option
        
        let wildThreatImageGesture = UITapGestureRecognizer(target: self, action:(#selector(ReportCategoryPopUpView.wildThreatSelected)))
        wildThreatImageGesture.numberOfTapsRequired = 1
        WildLifeThreatImage.userInteractionEnabled = true
        WildLifeThreatImage.addGestureRecognizer(wildThreatImageGesture)
        
        
        //Other option
        
        let OtherImageGesture = UITapGestureRecognizer(target: self, action:(#selector(ReportCategoryPopUpView.otherSelected)))
        OtherImageGesture.numberOfTapsRequired = 1
        OtherImage.userInteractionEnabled = true
        OtherImage.addGestureRecognizer(OtherImageGesture)
    }
    
    func animalSelected(sender:AnyObject)
    {
        clearBackgroundOfOptions()
        
        let newSwiftColor = UIColor(red: 130, green: 170, blue: 180)
        AnimalsImage.backgroundColor  = newSwiftColor
        choosedCategory = "Animals"
        
    }
    
    func weatherSelected()
    {
        clearBackgroundOfOptions()
        
        let newSwiftColor = UIColor(red: 130, green: 170, blue: 180)
        WeatherImage.backgroundColor  = newSwiftColor
        choosedCategory = "Weather"
        
    }
    
    func floodSelected()
    {
        clearBackgroundOfOptions()
        let newSwiftColor = UIColor(red: 130, green: 170, blue: 180)
        FloodImage.backgroundColor  = newSwiftColor
        choosedCategory = "Flood"
        
    }
    
    func fireSelected()
    {
        clearBackgroundOfOptions()
        let newSwiftColor = UIColor(red: 130, green: 170, blue: 180)
        FireImage.backgroundColor  = newSwiftColor
        choosedCategory = "Fire"
        
    }
    
    
    func roadConditionSelected(sender:AnyObject)
    {
        clearBackgroundOfOptions()
        
        let newSwiftColor = UIColor(red: 130, green: 170, blue: 180)
        RoadCondition.backgroundColor  = newSwiftColor
        choosedCategory = "RoadConditions"
        
    }
    
    func wildThreatSelected()
    {
        clearBackgroundOfOptions()
        
        let newSwiftColor = UIColor(red: 130, green: 170, blue: 180)
        WildLifeThreatImage.backgroundColor  = newSwiftColor
        choosedCategory = "WildThreat"
        
    }
    
    func otherSelected()
    {
        clearBackgroundOfOptions()
        let newSwiftColor = UIColor(red: 130, green: 170, blue: 180)
        OtherImage.backgroundColor  = newSwiftColor
        choosedCategory = "Other"
        
    }
    
    
    
    
    //dismiss the view
    func dismissView()
    {
        self.view.removeFromSuperview()
        
    }
    
    
    func clearBackgroundOfOptions()
    {
        //let newSwiftColor = UIColor(red: 130, green: 170, blue: 180)
        AnimalsImage.backgroundColor  = UIColor.whiteColor()
        RoadCondition.backgroundColor  = UIColor.whiteColor()
        FireImage.backgroundColor  = UIColor.whiteColor()
        FloodImage.backgroundColor = UIColor.whiteColor()
        WeatherImage.backgroundColor  = UIColor.whiteColor()
        OtherImage.backgroundColor  = UIColor.whiteColor()
        WildLifeThreatImage.backgroundColor  = UIColor.whiteColor()
    }
    
    
    func makeRoundCornerForOptions()
    {
        
        AnimalsImage.layer.cornerRadius = 5
        AnimalsImage.layer.masksToBounds = true
        WeatherImage.layer.cornerRadius = 5
        WeatherImage.layer.masksToBounds = true
        FireImage.layer.cornerRadius = 5
        FireImage.layer.masksToBounds = true
        FloodImage.layer.cornerRadius = 5
        FloodImage.layer.masksToBounds = true
        
        WeatherImage.layer.cornerRadius = 5
        WeatherImage.layer.masksToBounds = true
        OtherImage.layer.cornerRadius = 5
        OtherImage.layer.masksToBounds = true
        WildLifeThreatImage.layer.cornerRadius = 5
        WildLifeThreatImage.layer.masksToBounds = true
    }
    
   
        
}
    
    

