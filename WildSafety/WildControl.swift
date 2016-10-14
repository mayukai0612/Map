//
//  WildControl.swift
//  Map
//
//  Created by Yukai Ma on 22/09/2016.
//  Copyright © 2016 Yukai Ma. All rights reserved.
//

import UIKit

class WildControl: UIViewController {
    
    
    @IBOutlet weak var firstLocLabel: UILabel!
    
    @IBOutlet weak var fisrtOrgLabel: UILabel!
    
    @IBOutlet weak var firstEmailLabel: UILabel!
    
    @IBOutlet weak var firstPhoneLabel: UILabel!
    
    
    @IBOutlet weak var firstPhoneImage: UIImageView!
    
    
    
    @IBOutlet weak var secLocLabel: UILabel!
    
    
    @IBOutlet weak var secOrgLabel: UILabel!
    
    
    @IBOutlet weak var secEmailLabel: UILabel!
    
    @IBOutlet weak var secPhoneLabel: UILabel!
    
    
    
    @IBOutlet weak var secPhoneImage: UIImageView!
    
    
    @IBOutlet weak var segment: UISegmentedControl!
   

    @IBAction func indexChanged(sender: AnyObject) {
        
        switch segment.selectedSegmentIndex
        {
        case 0:
            loadWildDogView()
        case 1:
            loadFeralCatView()
        case 2:
            loadFoxView()
        case 3:
            loadRabbitView()
        default:
            loadWildDogView()
            break;
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadWildDogView()
        addActionToPhoneImage()
        
        firstPhoneImage.tag = 1
        secPhoneImage.tag = 2

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    func loadWildDogView()
    {
        
        firstPhoneLabel.text = "0400854386"
        fisrtOrgLabel.text = ""
        firstEmailLabel.text = ""
        firstLocLabel.text  = "Corryong: Biggara, Nariel, Lucyvale, Cudgewa, Tintaldra, Walwa, Burrowye, Shelley, Mt. Alfred"
        
        secPhoneLabel.text = "0409188465"
        secOrgLabel.text = ""
        secEmailLabel.text = ""
        secLocLabel.text  = "Tallangatta: Koetong, Granya, Tallangatta Valley, Mitta Valley, Sandy Creek, Gundowring"
//        
//        
//        thirdPhoneLabel.text = "0427 538 708"
//        
//        thirdAddressLab.text  = "Ovens: Myrtleford, Mt. Beauty, Beechworth, Yackandandah, King Valley"
    
    }
    
    func loadFeralCatView()
    {
        firstPhoneLabel.text = "0403901865"
        
        firstLocLabel.text  = "Loddon-Mallee"
        fisrtOrgLabel.text = "ABC Pest Management Services"
        firstEmailLabel.text = "Email:Planes1@internode.on.net"
        
        
        secPhoneLabel.text = "131963"
        
        secLocLabel.text  = "Grampians"
        
        secOrgLabel.text = "Wyperfeld National Park"
        
        secEmailLabel.text = "Email:info@parks.vic.gov.au"
        
        //
    
    }
    
    func loadFoxView()
    {
        firstPhoneLabel.text = "0418589237"
        
        firstLocLabel.text  = "Gippsland"
        fisrtOrgLabel.text = "Environmental Maintenance Service"
        firstEmailLabel.text = "Email:gipps.enviro@bigpond.com"
        
        
        secPhoneLabel.text = "131963"
        
        secLocLabel.text  = "Grampians"
        
        secOrgLabel.text = "Wyperfeld National Park"
        
        secEmailLabel.text = "Email:  info@parks.vic.gov.au"
    }
    
    func loadRabbitView()
    {
        firstPhoneLabel.text = "0418589237"
        
        firstLocLabel.text  = "Gippsland"
        fisrtOrgLabel.text = "Vermin Solutions Victoria"
        firstEmailLabel.text = "Email:gipps.enviro@bigpond.com"
        
        
        secPhoneLabel.text = "0355712526"
        
        secLocLabel.text  = "Grampians"
        
        secOrgLabel.text = "Glenelg Hopkins CMA"
        
        secEmailLabel.text = "Email:ghcma@ghcma.vic.gov.au"
    }
    
    func addActionToPhoneImage()
    {
        //add action to image
        let fisrtTapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(WildControl.makePhoneCall(_:)))
        firstPhoneImage.userInteractionEnabled = true
        firstPhoneImage.addGestureRecognizer(fisrtTapGestureRecognizer)
        
        //add action to image
        let secTapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(WildControl.makePhoneCall(_:)))
        secPhoneImage.userInteractionEnabled = true
        secPhoneImage.addGestureRecognizer(secTapGestureRecognizer)
        


    
    }
    
    func makePhoneCall(recognizer:UIPanGestureRecognizer)
    {
        let phoneImage = recognizer.view as! UIImageView
        var phoneNumber :String?
        if(phoneImage.tag == 1)
        {
           phoneNumber = firstPhoneLabel.text?.trim()
        }
        else if(phoneImage.tag == 2)
        {
            phoneNumber = secPhoneLabel.text?.trim()
        }
        
        
        if let url = NSURL(string: "tel://\(phoneNumber!)") {
            UIApplication.sharedApplication().openURL(url)
        }
    
    }

}
