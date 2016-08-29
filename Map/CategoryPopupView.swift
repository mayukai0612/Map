//
//  PopUpViewController.swift
//  PopUp
//
//  Created by Andrew Seeley on 6/06/2016.
//  Copyright © 2016 Seemu. All rights reserved.
//

import UIKit

class CategoryPopupView: UIViewController {
    
    @IBOutlet weak var displayedView: UIView!
    
    @IBOutlet weak var closeBtn: UIImageView!
    
    @IBOutlet weak var pathFindingOption: UIImageView!
    @IBOutlet weak var groupOption: UIImageView!
    
    @IBOutlet weak var personalOption: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
        
        self.displayedView.layer.cornerRadius = 5
        self.displayedView.layer.masksToBounds = true
        
       addActionOnImages()
        makeRoundCornerForOptions()
        
        self.showAnimate()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func ClosePopUp(sender: AnyObject) {
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
        let singleTap = UITapGestureRecognizer(target: self, action:(#selector(CategoryPopupView.tapDetected)))
        singleTap.numberOfTapsRequired = 1
        closeBtn.userInteractionEnabled = true
        closeBtn.addGestureRecognizer(singleTap)
        
        //personal option
        let st = UITapGestureRecognizer(target: self, action:(#selector(CategoryPopupView.personalSelected)))
        st.numberOfTapsRequired = 1
        personalOption.userInteractionEnabled = true
        personalOption.addGestureRecognizer(st)
        
        //group option
        
        let tapFirst = UITapGestureRecognizer(target: self, action:(#selector(CategoryPopupView.groupSelected)))
        tapFirst.numberOfTapsRequired = 1
        groupOption.userInteractionEnabled = true
        groupOption.addGestureRecognizer(tapFirst)
        
        
        //path finding option
        
        let oneTap = UITapGestureRecognizer(target: self, action:(#selector(CategoryPopupView.pathFindingSelected)))
        oneTap.numberOfTapsRequired = 1
        pathFindingOption.userInteractionEnabled = true
        pathFindingOption.addGestureRecognizer(oneTap)
    }
    
    func personalSelected()
    {
        clearBackgroundOfOptions()

        let newSwiftColor = UIColor(red: 130, green: 170, blue: 180)
        personalOption.backgroundColor  = newSwiftColor
        
    }
    
    func groupSelected()
    {
        clearBackgroundOfOptions()

        let newSwiftColor = UIColor(red: 130, green: 170, blue: 180)
        groupOption.backgroundColor  = newSwiftColor
        
    }
    
    func pathFindingSelected()
    {
        clearBackgroundOfOptions()
        let newSwiftColor = UIColor(red: 130, green: 170, blue: 180)
        pathFindingOption.backgroundColor  = newSwiftColor
        
    }
    
    func tapDetected()
    {
        self.view.removeFromSuperview()

    }
    
    
    func clearBackgroundOfOptions()
    {
        let newSwiftColor = UIColor(red: 130, green: 170, blue: 180)
        personalOption.backgroundColor  = UIColor.whiteColor()
        groupOption.backgroundColor  = UIColor.whiteColor()
        pathFindingOption.backgroundColor  = UIColor.whiteColor()
    }
   
    
    func makeRoundCornerForOptions()
    {
        
        personalOption.layer.cornerRadius = 5
        personalOption.layer.masksToBounds = true
    
        groupOption.layer.cornerRadius = 5
        groupOption.layer.masksToBounds = true
        pathFindingOption.layer.cornerRadius = 5
        pathFindingOption.layer.masksToBounds = true
    }
    
}
